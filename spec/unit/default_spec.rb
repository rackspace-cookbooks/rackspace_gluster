# encoding: utf-8

require 'chefspec'
require 'chefspec/berkshelf'

describe 'rackspace_gluster::default' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'ubuntu', version: '14.04') do |node|

      # stubs for commands for block devices, bc, and gluster
      stub_command('test -f /var/lib/apt/periodic/update-success-stamp').and_return(true) # apt
      stub_command('blkid -s TYPE -o value /dev/sdb').and_return(false) # no filesystem present
      stub_command("gluster peer status | egrep '^Hostname: 33.33.33.10'").and_return(false) # no peers yet
      stub_command("echo \"1 == `gluster peer status | egrep \"^Number of Peers: \" | awk '{print $4}'`\" | bc -l").and_return(0) # 0 peers
      stub_command("gluster volume info | egrep '^Volume Name: vol0$'").and_return(false) # no volume
      stub_command("gluster volume info vol0 | egrep \"^auth.allow: 127.0.0.1,33.33.33.*\"").and_return(false) # no property set on volume
      stub_command("gluster volume info vol0| egrep '^Status: Started'").and_return(false) # need to start volume

      # we're presenting we're gluster02
      node.automatic_attrs['hostname'] = 'gluster02'

      # unit test a two node gluster cluster
      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['volume'] = 'vol0'
      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['replica'] = '2'

      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['auth_clients'] = '127.0.0.1,33.33.33.*'

      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['ip'] = '33.33.33.10'
      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['block_device'] = '/dev/sdb'
      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['mount_point'] = '/mnt/brick0'
      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['brick_dir'] = '/mnt/brick0/brick'

      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['ip'] = '33.33.33.11'
      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['block_device'] = '/dev/sdb'
      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['mount_point'] = '/mnt/brick0'
      node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['brick_dir'] = '/mnt/brick0/brick'

    end.converge(described_recipe)
  end

  it 'should install the correct packages' do
    chef_run.should install_package 'xfsprogs'
    chef_run.should install_package 'glusterfs-server'
    chef_run.should install_package 'glusterfs-client'
    chef_run.should install_package 'vnstat'
    chef_run.should install_package 'bc'
  end

  it '/mnt/brick0/brick should exist with permissions and ownership' do
    expect(chef_run)
      .to create_directory('/mnt/brick0/brick')
      .with_owner('root')
      .with_group('root')
      .with_mode('755')
  end

  it 'should check and fail, then make a new filesystem on /dev/sdb' do
    expect(chef_run).to run_execute('mkfs.xfs -i size=512 /dev/sdb')
  end

  it 'should execute all of the gluster commands to create the cluster' do
    expect(chef_run).to run_execute 'gluster peer probe 33.33.33.10'
    expect(chef_run).to run_execute 'gluster volume create vol0 replica 2 33.33.33.10:/mnt/brick0/brick 33.33.33.11:/mnt/brick0/brick'
    expect(chef_run).to run_execute 'gluster volume set vol0 auth.allow 127.0.0.1,33.33.33.*'
    expect(chef_run).to run_execute 'gluster volume start vol0'

  end

end

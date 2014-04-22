# -*- mode: ruby -*-
# vi: set ft=ruby :

boxes = [
{ :name => :gluster01, :ip => '33.33.33.10', :port => 2201 },
{ :name => :gluster02, :ip => '33.33.33.11', :port => 2202 },
]

Vagrant.configure("2") do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "vagrant-oracle-vm-saucy64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-amd64-vagrant-disk1.box"
 

  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # Name and build three servers
  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.host_name =   "%s" % opts[:name].to_s
      # config.ssh.port = opts[:port]
      config.vm.network :private_network, ip: opts[:ip]
      # CentOS requires, otherwise notty error
      config.ssh.pty = true
      config.omnibus.chef_version = "11.0"
    end

    # need a second disk for the gluster brick (5GB)
    config.vm.provider :virtualbox do |config|
      file_to_disk = '/tmp/temp_disk_%s.vdi' % opts[:name].to_s
      config.customize ['createhd', '--filename', file_to_disk, '--size', 5 * 1024]
      config.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
    end
  end

#  config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | bash"
#   config.vm.provision :shell, :inline => "apt-get update"

  config.vm.provision :chef_solo do |chef|
 
    # chef.synced_folder_type = 'rsync'
    chef.run_list = [
        "recipe[rackspace_gluster_test::test]", # test wrapper cookbook
    ]
  end
end

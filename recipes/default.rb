#
# cookbook name:: rackspace_gluster
# recipe:: default
# Author:: rackspace@rackspace.com
#
# Copyright 2014, Rackspace
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'chef-sugar'

# repo dependencies for php-fpm
if platform_family?('rhel')
  include_recipe 'yum'
  include_recipe 'yum-ius'
  include_recipe 'yum-epel'
  include_recipe 'rackspace_gluster::yum-glusterfs-epel'
elsif platform_family?('debian')
  include_recipe 'apt'
end

admin_packages = %w(
  xfsprogs
  glusterfs-server
  glusterfs-client
  vnstat
  bc
)

admin_packages.each do | admin_package |
  package admin_package do
    action :install
  end
end

if debian?
  service_name = 'glusterfs-server'
else
  service_name = 'glusterd'
end

service service_name do
  action [:enable, :start]
  # IIRC RHEL/CentOS won't typically start a service on package install, but Debian/Ubuntu flavors will
  # no harm in enabling this for Debian/Ubuntu though
  #only_if { node['platform_family'] == 'rhel' }
end

# handy-dandy shorthand variable
baseconfig = node['rackspace_gluster']['config']['server']

# foreach gluster cluster
baseconfig['glusters'].each_with_index do |(gluster_name, gluster), _gluster_index|

  log 'configuring gluster cluster ' + gluster_name

  # how many nodes are we
  node_cnt = gluster['nodes'].count
  peer_cnt = node_cnt - 1
  is_last_node = false

  gluster['nodes'].each_with_index do |(gluster_node_name, gluster_node), node_index|

    log 'examining node ' + gluster_node_name

    # if it isn't *this* node (by name, must match!)
    if gluster_node_name != node['hostname']
      next
    end

    # do any brick setup (idempotent)
    block_device = gluster_node['block_device']
    mount_point = gluster_node['mount_point']
    brick_dir = gluster_node['brick_dir']
    log 'Matched this hostname to configuration for block device ' + block_device + ' mounting to ' + mount_point + ' with brick in ' + brick_dir

    # mkfs on block device (only once)
    execute "mkfs.xfs -i size=512 #{block_device}" do
      command "mkfs.xfs -i size=512 #{block_device}"
      not_if "blkid -s TYPE -o value #{block_device}"
    end

    # create and fixup the mount point
    directory mount_point do
      owner 'root'
      group 'root'
      mode '755'
      recursive true
    end

    # mount the mountpoint
    mount mount_point do
      device block_device
      fstype 'xfs'
      options 'rw'
      action [:mount, :enable]
    end

    # gluster no longer likes mount points directly as bricks,
    # get the new attribute for a subdir of the mount point
    directory brick_dir do
      owner 'root'
      group 'root'
      mode '755'
      recursive true
    end

    # true IFF this node's index is the last in the array
    if node_index == node_cnt - 1
      is_last_node = true
    end
  end # end nodes

  # if this node was the one we just touched, *and* it isn't the last in the gluster
  unless is_last_node
    next
  end

  # build a list of volumes
  volume_nodes = []
  gluster['nodes'].each_with_index do |(_gluster_node_name, gluster_node), _node_index|
    node_ip = gluster_node['ip']
    brick_dir = gluster_node['brick_dir']
    volume_nodes.push("#{node_ip}:#{brick_dir}")
  end # each node

  # peer up the nodes
  gluster['nodes'].each_with_index do |(gluster_node_name, gluster_node), _node_index|
    node_ip = gluster_node['ip']
    execute "gluster peer probe #{node_ip}" do
      command "gluster peer probe #{node_ip}"
      retries 10      # just retry while other nodes get on-line
      retry_delay 15
      not_if { gluster_node_name == node['hostname'] }
      not_if "gluster peer status | egrep '^Hostname: #{node_ip}'"
    end # execute
  end # each node

  volume = gluster['volume']
  auth_clients = gluster['auth_clients']

  # if no replica key, don't call it a replica
  if gluster.key?('replica')
    replica_cnt = gluster['replica']
    replica_cmd = "replica #{replica_cnt}"
  end

  # create the volume if it doesn't exist
  execute "gluster volume create #{volume} #{replica_cmd} #{volume_nodes.join(' ')}" do
    command "gluster volume create #{volume} #{replica_cmd} #{volume_nodes.join(' ')}"
    retries 5
    retry_delay 5
    not_if "gluster volume info | egrep '^Volume Name: #{volume}$'"
    only_if "echo \"#{peer_cnt} == `gluster peer status | egrep \"^Number of Peers: \" | awk '{print $4}'`\" | bc -l"
  end

  # !!! CHANGES TO AUTHENTICATION REQUIRES MANUAL STOP/START OF VOLUME FOR NOW !!!
  execute "gluster volume set #{volume} auth.allow #{auth_clients}" do
    command "gluster volume set #{volume} auth.allow #{auth_clients}"
    retries 1
    retry_delay 5
    not_if "gluster volume info #{volume} | egrep \"^auth.allow: #{auth_clients}\""
  end

  # start the volume
  execute "gluster volume start #{volume}" do
    command "gluster volume start #{volume}"
    retries 1
    retry_delay 5
    not_if "gluster volume info #{volume}| egrep '^Status: Started'"
  end
end # end gluster

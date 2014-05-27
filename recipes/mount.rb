#
# cookbook name:: rackspace_gluster
# recipe:: default
#
# copyright 2014, rackspace
#
#

log 'installing gluster and mounting bricks..'

admin_packages = %w(
  xfsprogs
  glusterfs-server
  glusterfs-client
  vnstat
  bc
)

include_recipe 'rackspace_apt'
admin_packages.each do | admin_package |
  package admin_package do
    action :install
  end
end

gluster_node = node['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']["#{node["hostname"]}"]



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

node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']["#{node["hostname"]}"]['ip'] = "#{node["ipaddress"]}"
node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']["#{node["hostname"]}"]['block_device'] = gluster_node['block_device']
node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']["#{node["hostname"]}"]['mount_point'] = gluster_node['mount_point']
node.set['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']["#{node["hostname"]}"]['brick_dir'] = gluster_node['brick_dir']

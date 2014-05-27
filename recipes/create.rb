#
# cookbook name:: rackspace_gluster
# recipe:: default
#
# copyright 2014, rackspace
#
#

log 'creating new gluster volume..'

# find all nodes with rackspace_gluster::mount
log 'Searching for all gluster nodes..........'
auth_list = "127.0.0.1"
gfs_nodes = []
if !Chef::Config['solo']
  log 'Searching for other gluster nodes..........'
  auth_list = "127.0.0.1"
  search(:node, 'run_list:recipe\[rackspace_gluster\:\:mount\]').each do | gfs_node |
    log 'Found gfs node: ' + gfs_node["hostname"].to_s + ' ' + gfs_node["ipaddress"].to_s
    auth_list = auth_list + ","+ gfs_node["ipaddress"].to_s
    gfs_nodes.push(gfs_node)
  end
else
  Chef::Log.warn 'Running Chef Solo; not searching for other gluster nodes on chef server.'
end

log 'gfs_nodes array: ' + gfs_nodes.to_s

if gfs_nodes.length < 2 
 raise "Less than two gfs nodes found!! Requires minimum two nodes with block storage added as cbs_gfs1. Aborting...."
end


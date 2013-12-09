#
# Cookbook Name:: rackops-gluster
# Recipe:: client
#
# Copyright 2013, Rackspace
#
# All rights reserved - Do Not Redistribute
#
package 'glusterfs-client'
#package 'glusterfs-common'
#package 'fuse-utils'

# create client mountpoint
directory "/mnt/gluster-volume" do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
end

# mount glusterfs
# mount -t glusterfs 162.242.223.240:/vol-c1v0 /mnt/glusterfs/
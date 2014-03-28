#
# Cookbook Name:: rackops-gluster
# Recipe:: client
#
# Copyright 2013, Rackspace
#
# All rights reserved - Do Not Redistribute
#

package 'glusterfs-client'

# create client mountpoint
directory '/mnt/gluster-volume' do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
end

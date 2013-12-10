#
# Cookbook Name:: rackops-gluster
# Recipe:: server
#
# Copyright 2013, Rackspace
#
# All rights reserved - Do Not Redistribute
#

package 'xfsprogs'
package 'glusterfs-server'
package 'vnstat'

cluster = ""
block_device = ""
mount_point = ""
volume = ""
replica_cnt = 0
node_cnt = 0
peer_cnt = 0
auth_clients = ""
is_last_node = false

node[:glusters].each do |g|
  g[:nodes].each do |n|
    if n == node[:rackspace][:private_ip] # or: node[:ipaddress], node[:private_ips][]
      cluster = g[:name]
      block_device = g[:block_device]
      mount_point = g[:mount_point]
      volume = g[:volume]
      replica_cnt = g[:replica_cnt]
      auth_clients = g[:auth_clients]
      node_cnt = g[:nodes].count
      peer_cnt = node_cnt - 1
      is_last_node = g[:nodes].index(node[:rackspace][:private_ip]) ==  node_cnt - 1
      break
    end
  end
end

unless cluster.empty?
  execute "mkfs.xfs" do
    command "mkfs.xfs -i size=512 #{block_device}"
    not_if { system("blkid -s TYPE -o value #{block_device}") }
  end
  
  directory "#{mount_point}" do
     owner 'root'
     group 'root'
     mode 0755
     recursive true
  end
  
  mount "#{mount_point}" do
    device "#{block_device}"
    fstype "xfs"
    options "rw"
    action [:mount, :enable]
  end

  volume_nodes = []
  node[:glusters].each do |g|
    if cluster == g[:name]
      g[:nodes].each do |n|
        volume_nodes.push("#{n}:#{mount_point}")
      end
    end
  end

  if is_last_node
    # peer up the nodes
    node[:glusters].each do |g|
      if cluster == g[:name]
        g[:nodes].each do |n|
          execute "gluster peer probe #{n}" do
            command "gluster peer probe #{n}"
            retries 1
            retry_delay 1
            not_if { n == node[:rackspace][:private_ip] }
            not_if "gluster peer status | egrep '^Hostname: #{n}'"
          end
        end
      end
    end

    # create the volume if it doesn't exist
    execute "gluster volume create #{volume} replica #{replica_cnt} #{volume_nodes.join(" ")}" do
      command "gluster volume create #{volume} replica #{replica_cnt} #{volume_nodes.join(" ")}"
      retries 1
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
  end
end
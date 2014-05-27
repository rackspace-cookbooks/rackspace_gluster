#
# cookbook name:: rackspace_gluster
# recipe:: default
#
# copyright 2014, rackspace
#
#

# if gluster volume already exists add any new nodes bricks to the volume
# else create a new gluster volume


volume_already_exists = false
ruby_block "find existing gfs volumes" do
block do
  output = 'gluster volume info | grep -i "Volume Name:" | awk \'\{print $NF\}\'' 
end
  action :create
end
volume_already_exists = true unless output == gluster['volume'] 

if volume_already_exists
  include_recipe 'rackspace_gluster::extend'
else
  include_recipe 'rackspace_gluster::create'
end



default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1'] = {}

default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['volume'] = 'vol0'
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['replica'] = '2'

# note, these IPs (next line and below) correspond to a cloud network configured in Vagrantfile
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['auth_clients'] = ['127.0.0.1', '33.33.33.*']

default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['ip'] = '33.33.33.10'
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['block_device'] = '/dev/sdb'
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['mount_point'] = '/mnt/brick0'

default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['ip'] = '33.33.33.11'
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['block_device'] = '/dev/sdb'
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster02']['mount_point'] = '/mnt/brick0'

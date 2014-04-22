
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1'] = {}

default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['volume'] = 'vol0'
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['replica'] = '2'
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['auth_clients'] = ['10.176.129.211', '10.176.130.99']

default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01'] = {}
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['ip'] = '10.176.163.120'
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['block_device'] = '/dev/xvde1'
default['rackspace_gluster']['config']['server']['glusters']['Gluster Cluster 1']['nodes']['gluster01']['mount_point'] = '/mnt/brick0'

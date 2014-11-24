# glusterfs-epel
default['yum']['glusterfs-epel']['repositoryid'] = 'glusterfs-epel'

default['yum']['glusterfs-epel']['description'] = 'GlusterFS is a clustered file-system capable of scaling to several petabytes.'
default['yum']['glusterfs-epel']['baseurl'] = "http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/epel-#{node[:platform_version].split('.')[0]}/#{node[:kernel][:machine]}/"
default['yum']['glusterfs-epel']['gpgkey'] = 'http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/pub.key'

default['yum']['glusterfs-epel']['failovermethod'] = 'priority'
default['yum']['glusterfs-epel']['gpgcheck'] = true
default['yum']['glusterfs-epel']['enabled'] = true
default['yum']['glusterfs-epel']['managed'] = true

# glusterfs-noarch-epel
default['yum']['glusterfs-noarch-epel']['repositoryid'] = 'glusterfs-noarch-epel'

default['yum']['glusterfs-noarch-epel']['description'] = 'GlusterFS is a clustered file-system capable of scaling to several petabytes.'
default['yum']['glusterfs-noarch-epel']['baseurl'] = "http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/epel-#{node[:platform_version].split('.')[0]}/noarch"
default['yum']['glusterfs-noarch-epel']['gpgkey'] = 'http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/pub.key'

default['yum']['glusterfs-noarch-epel']['failovermethod'] = 'priority'
default['yum']['glusterfs-noarch-epel']['gpgcheck'] = true
default['yum']['glusterfs-noarch-epel']['enabled'] = true
default['yum']['glusterfs-noarch-epel']['managed'] = true

# glusterfs-noarch-epel
default['yum']['glusterfs-source-epel']['repositoryid'] = 'glusterfs-source-epel'

default['yum']['glusterfs-source-epel']['description'] = 'GlusterFS is a clustered file-system capable of scaling to several petabytes.'
default['yum']['epglusterfs-source-epelel']['baseurl'] = "http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/epel-#{node[:platform_version].split('.')[0]}/SRPMS"
default['yum']['glusterfs-source-epel']['gpgkey'] = 'http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/pub.key'

default['yum']['glusterfs-source-epel']['failovermethod'] = 'priority'
default['yum']['glusterfs-source-epel']['gpgcheck'] = true
default['yum']['glusterfs-source-epel']['enabled'] = false
default['yum']['glusterfs-source-epel']['managed'] = true

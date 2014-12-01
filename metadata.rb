name             'rackspace_gluster'
maintainer       'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license          'All rights reserved'
description      'Installs/Configures gluster server for rackspace'
version          '0.3.0'

depends 'apt'
depends 'yum'
depends 'yum-ius'
depends 'yum-epel'

supports 'debian'
supports 'ubuntu'

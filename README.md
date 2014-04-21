rackspace_gluster Cookbook
========================
Gluster cookbook. Creates a Distributed-Replicate cluster.

![Gluster Distributed-Replicate](img/gluster-dv.png)

Requirements
------------
...
#### additional packages installed
- `xfsprogs`
- `vnstat`

Usage
-----
#### rackspace_gluster::server
Add service net IPs to Chef environment.
NOTE: The order is very important to Gluster when it comes to creating the volume.

Sample environment:
    
    "glusters": [
      {
        "name": "Gluster Cluster 1",
        "block_device": "/dev/xvde1",
        "mount_point": "/data/gv0/brick1",
        "volume": "vol0",
        "replica_cnt": 2,
        "auth_clients": "10.176.129.211,10.176.130.99",
        "nodes": [
          "10.176.163.120",
          "10.176.164.69",
          "10.176.163.237",
          "10.176.161.105"
        ]
      },
      {
        "name": "Gluster Cluster 2",
        "block_device": "/dev/xvde1",
        "mount_point": "/data/gv0/brick1",
        "volume": "vol1",
        "replica_cnt": 2,
        "auth_clients": "*",
        "nodes": [
          "10.0.0.1",
          "10.0.0.2",
          "10.0.0.3",
          "10.0.0.4"
        ]
      }
    ]


Testing
=======

Pleas see testing guidelines at [contributing](https://github.com/rackspace-cook
books/contributing/blob/master/CONTRIBUTING.md)

Contributing
============

Please see contributing guidelines at [contributing](https://github.com/rackspac
e-cookbooks/contributing/blob/master/CONTRIBUTING.md)

License and Authors
-------------------
Authors: Ted Neykov   <ted.neykov@rackspace.com>
Authors: Martin Smith <martin.smith@rackspace.com>

```text
Copyright:: 2014, Rackspace, US Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
rackops-gluster Cookbook
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
#### rackops-gluster::server
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



Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Ted Neykov <ted.neykov@rackspace.com>
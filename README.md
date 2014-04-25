rackspace_gluster Cookbook
========================
Gluster cookbook. Creates a Distributed, Replicated cluster. 

![Documentation from Red Hat](https://access.redhat.com/site/documentation/en-US/Red_Hat_Storage/)

Requirements
------------
...
#### additional packages installed
- `xfsprogs`
- `vnstat`

Usage
-----
#### rackspace_gluster::server

We longer assume that there is only one brick per chef node in this cookbook. Eventually 
this could be refactored into separate config arrays for bricks and volumes, which 
would allow for arbitrary numbers of bricks per node. 

Additionally, please note that this does no client configuration yet, but this would be trivial to add.

NOTE: The order is very important to Gluster when it comes to creating the volume. This cookbook does peer probes and creates the volume on the last host in the config array.

[Sample environment](test/fixtures/cookbooks/rackspace_gluster_test/attributes/default.rb)

Testing
=======

Please see testing guidelines at [contributing](https://github.com/rackspace-cookbooks/contributing/blob/master/CONTRIBUTING.md). This cookbook comes with RSpec and ChefSpec tests, as well as a Vagrantfile for a 2 node replicated cluster.

Contributing
============

Please see contributing guidelines at [contributing](https://github.com/rackspace-cookbooks/contributing/blob/master/CONTRIBUTING.md)

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
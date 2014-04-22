# -*- mode: ruby -*-
# vi: set ft=ruby :

boxes = [
{ :name => :gluster01 },
{ :name => :gluster02 },
]

Vagrant.configure("2") do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = 'dummy'
  config.vm.box_url = 'https://github.com/mitchellh/vagrant-rackspace/raw/master/dummy.box'

  # ssh key to use
  config.ssh.private_key_path = ENV['RS_KEYPATH'] if ENV['RS_KEYPATH']

  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  config.vm.provider :rackspace do |rs|
    rs.username = ENV['OS_USERNAME'] if ENV['OS_USERNAME']
    rs.api_key  = ENV['OS_PASSWORD'] if ENV['OS_PASSWORD']

    if ENV['RS_FLAVOR']
      rs.flavor = ENV['RS_FLAVOR'] else rs.flavor = 'performance1-4'
    end
    if ENV['RS_IMAGE']
      rs.image = ENV['RS_IMAGE'] else rs.flavor = /Ubuntu 12.04/
    end

    rs.rackspace_region = ENV['RS_REGION'] if ENV['RS_REGION']

    rs.key_name = ENV['RS_KEYNAME'] if ENV['RS_KEYNAME']
    #rs.rackconnect = ENV['RS_RACKCONNECT'] if ENV['RS_RACKCONNECT']
    #rs.network '50b3c127-881f-43d2-901d-fc2d64874853'
  end

  # Name and build three servers
  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.host_name =   "%s.vagrant" % opts[:name].to_s
      # config.ssh.port = opts[:ssh_port]
      # CentOS requires, otherwise notty error
      config.ssh.pty = true
      config.omnibus.chef_version = "11.0"
    end
  end

#  config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | bash"
#   config.vm.provision :shell, :inline => "apt-get update"

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
        "recipe[rackspace_gluster_test::test]", # test wrapper cookbook
    ]
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# require 'berkshelf/vagrant'

boxes = [
{ :name => :gluster01, :ip => '33.33.33.10' },
{ :name => :gluster02, :ip => '33.33.33.11' },
]

Vagrant.configure("2") do |config|

  # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = 'opscode-ubuntu-14.04'
    config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'
#    config.vm.box = "precise-server-cloudimg-amd64-vagrant-disk1"
#    config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
#    config.vm.box = 'opscode-ubuntu-12.04'
#    config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box'
 

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = "./Berksfile.vagrant"

  config.omnibus.chef_version = :latest

  # Name and build three servers
  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.host_name =   "%s" % opts[:name].to_s
      config.vm.network :private_network, ip: opts[:ip]

      # need a second disk for the gluster brick (5GB)
      config.vm.provider :virtualbox do |config|
        file_to_disk = '/tmp/temp_disk_%s.vdi' % opts[:name].to_s
        config.customize ['createhd', '--filename', file_to_disk, '--size', 5 * 1024]
        config.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
      end
    end
  end

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      # wrapper cookbook for testing
      "recipe[rackspace_gluster_test::test]"
    ]
  end
end

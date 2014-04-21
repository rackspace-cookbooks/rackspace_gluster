require 'spec_helper'

describe 'rackspace_gluster::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates rackspace_gluster_globalconfig[/etc/gluster.conf]' do
    expect(chef_run).to create_rackspace_gluster_globalconfig('/etc/gluster.conf')
  end

end

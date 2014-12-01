# Encoding: utf-8
#
# Copyright 2014, Rackspace, US, Inc.
# Copyright 2013-2014 Chef Software, Inc.
# Copyright 2011 Fletcher Nichol
# Copyright 2010 VMware, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Originally from https://github.com/opscode-cookbooks/jenkins/blob/master/Rakefile
#
# Tasks can be called individually: bundle exec rake style_unit

require 'bundler/setup'

namespace :style do
  require 'rubocop/rake_task'
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby) do |task|
    # see templatestack's .rubocop.yml for comparison
    task.patterns = ['**/*.rb']

    # only show the files with failures
    task.formatters = ['files']

    # abort rake on failure
    task.fail_on_error = true
  end

  require 'foodcritic'
  require 'foodcritic/rackspace/rules/version' # ensure loaded
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    # 'search_gems' doesn't work, but :search_gems does
    # rubocop:disable Style/HashSyntax
    t.options = { :search_gems => true,
                  :fail_tags => ['correctness','rackspace'],
                  :chef_version => '11.6.0'
                }
    # rubocop:enable Style/HashSyntax
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

require 'kitchen'
desc 'Run Test Kitchen integration tests'
task :integration do
  Kitchen.logger = Kitchen.default_file_logger
  sh 'kitchen test -c'
end

desc 'Destroy test kitchen instances'
task :destroy do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each do |instance|
    instance.destroy
  end
end

require 'rspec/core/rake_task'
desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec) do |t, args|
  t.rspec_opts = 'test/unit'
end

# The default rake task should just run it all
task default: ['style', 'spec', 'integration']

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
  rescue LoadError
    puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end

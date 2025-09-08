require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "cucumber/rake/task"

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:cucumber)

task default: [:spec, :cucumber]

desc "Run RuboCop"
task :rubocop do
  sh "rubocop"
end

desc "Generate documentation"
task :doc do
  sh "yard doc"
end


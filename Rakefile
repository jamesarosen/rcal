unless Object.const_defined?(:PROJECT_ROOT)
  PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
end

$: << File.join(PROJECT_ROOT, 'lib')

require 'rake/rdoctask'
require 'rake/testtask'

desc 'Run all tests'
task :default => ['test:run']

task :doc => ['doc:rdoc']
task :test => ['test:run']

namespace :doc do
  
  def rdoc_dir
    File.join(PROJECT_ROOT, 'doc', 'rdoc')
  end
  
  desc 'OSX only: open the RDoc in the default browser'
  task :open do
    raise 'Run doc:rdoc before doc:show' unless File.exists?(rdoc_dir)
    system "open #{File.join(rdoc_dir, 'index.html')}"
  end
  
  Rake::RDocTask.new(:rdoc) do |rdoc|
    rdoc.rdoc_dir = rdoc_dir
    rdoc.title    = 'Rcal Documentation'
    rdoc.template = "doc/jamis_template.rb"
    rdoc.rdoc_files.include('lib/**/*.rb', 'init.rb', 'doc/*.rdoc')
    rdoc.options << '--line-numbers'
    rdoc.options << '--inline-source'
  end
  
end

namespace :test do

  def lib_files
    FileList.new do |fl|
      fl.include File.join(PROJECT_ROOT, 'lib')
      fl.include File.join(PROJECT_ROOT, 'test', 'lib')
    end
  end
  
  def test_files
    FileList.new do |fl|
      fl.include "#{PROJECT_ROOT}/test/**/*_test.rb"
      fl.exclude "#{PROJECT_ROOT}/test/test_helper.rb"
      fl.exclude "#{PROJECT_ROOT}/test/lib/**/*.rb"
    end
  end

  desc 'Run all tests'
  Rake::TestTask.new(:run) do |t|
    t.libs = lib_files
    t.test_files = test_files
    t.verbose = true
  end
  
end
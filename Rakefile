unless Object.const_defined?(:PROJECT_ROOT)
  PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
end

$: << File.join(PROJECT_ROOT, 'lib')

require 'rake/rdoctask'

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
    rdoc.title    = "Rcal Documentation"
    rdoc.rdoc_files.include('lib/**/*.rb', 'init.rb', 'doc/*.rdoc')
    rdoc.options << '--line-numbers'
    rdoc.options << '--inline-source'
    rdoc.options << '--main' << 'lib/rcal.rb'
  end
  
end



require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--color", "-c", "-f progress", "-r test/spec/spec_helper.rb"]
  t.pattern = 'test/spec/**/*_spec.rb'  
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    #t.libs << 'lib'
    t.libs << 'test/lib'
    t.pattern = 'test/test/**/*_spec.rb'
    t.verbose = true
    t.output_dir = 'coverage'
    t.rcov_opts << '--exclude "gems/*"'
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

desc 'Generate documentation for the muck-activities plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'MuckActivity'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Translate this gem'
task :translate do
  file = File.join(File.dirname(__FILE__), 'config', 'locales', 'en.yml')
  system("babelphish -o -y #{file}")
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "muck-activities"
    gemspec.summary = "Activity engine for the muck system"
    gemspec.email = "justin@tatemae.com"
    gemspec.homepage = "http://github.com/tatemae/muck-activities"
    gemspec.description = "Activity engine for the muck system."
    gemspec.authors = ["Justin Ball", "Joel Duffin"]
    gemspec.rubyforge_project = 'muck-activities'
    gemspec.add_dependency "muck-engine"
    gemspec.add_dependency "muck-users"
    gemspec.add_dependency "muck-comments"
    gemspec.test_files.exclude 'test/**' # exclude test directory
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

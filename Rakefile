require 'bundler/gem_tasks'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.options = '--verbose --use-color'
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
    test.rcov_opts += ["--exclude /gems/"]
  end
rescue LoadError
 puts "Install rcov gem : `gem install rcov`"
end

desc "Default task"
task :default => "test"
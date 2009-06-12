require 'rake/testtask'

task :default => [:test]


desc "runs all tests"
task :test do
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/*test.rb']
    t.verbose = true
  end
end
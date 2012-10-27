require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "a_a_n"
  gem.homepage = "https://github.com/kot-begemot/association_as_name"
  gem.license = "MIT"
  gem.summary = %Q{Association as name}
  gem.description = %Q{Whenever you need assign an association by its attribute,
 like name, this gem comes to business.}
  gem.email = "test@example.com"
  gem.authors = ["E-Max"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new


require 'yard'
YARD::Rake::YardocTask.new
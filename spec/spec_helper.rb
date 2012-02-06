require 'rubygems'
require 'bundler'
Bundler.setup(:default, :development)

require 'active_record'
require 'a_a_n'
require 'rspec'
require 'ruby-debug'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ':memory:'
)

RSpec.configure do |config|
  config.before(:each) do
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.begin_db_transaction
    load File.join(File.dirname(__FILE__),'..', 'db', 'seeds.rb')
  end

  config.after(:each) do
    ActiveRecord::Base.connection.rollback_db_transaction
    ActiveRecord::Base.connection.decrement_open_transactions
  end
end
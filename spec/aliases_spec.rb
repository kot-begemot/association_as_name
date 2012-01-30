require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'countries'")
ActiveRecord::Base.connection.create_table(:countries) do |t|
  t.string :name
  t.string :iso_3166_a2
end

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'cities'")
ActiveRecord::Base.connection.create_table(:cities) do |t|
  t.string :name
  t.string :country_id
end

class Country < ActiveRecord::Base
  validates :name, :iso_3166_a2, :presence => true
end

class City < ActiveRecord::Base
  belongs_to :country

  acts_as_aan do
    association :country do
      [{ :iso_3166_a2 => :country_code}]
    end
  end

  validates :name, :presence => true
end

describe "Aliases" do

  it "Should assign a correct association by alias for existed object" do
    city = City.create!(:name => 'Roma')
    city.country_code = 'IT'
    city.save

    city.country.should == Country.find_by_name('Italy')
    city.reload
    city.country.should == Country.find_by_name('Italy')
  end

  it "Should not assign anything if record does not exists for existed object" do
    city = City.create!(:name => 'Roma')
    city.country_code = 'OZ'
    city.save

    city.country.should be_nil
    city.reload
    city.country.should be_nil
  end

  it "Should assign a correct association by alias for new object" do
    city = City.create!(:name => 'Roma', :country_code => 'IT')

    city.country.should == Country.find_by_name('Italy')
  end

  it "Should not assign anything if record does not exists for new object" do
    city = City.create!(:name => 'Roma', :country_code => 'OZ')

    city.country.should be_nil
    city.reload
    city.country.should be_nil
  end

  it "Should assign a correct association" do
    country = Country.find_by_name('Italy')
    city = City.create!(:name => 'Roma')
    city.country = country
    city.save

    city.country.should == Country.find_by_name('Italy')
    city.country_code == 'IT'
    city.reload
    city.country.should == Country.find_by_name('Italy')
    city.country_code == 'IT'
  end

  it "Should be overwritten by new object assigement" do
    country_1 = Country.find_by_name('Italy')
    city = City.create!(:name => 'Paris', :country_id => country_1.id)

    country_2 = Country.find_by_name('France')

    city.country = country_2
    city.country_code == 'FR'
    city.save
    city.reload
    city.country_code == 'FR'
  end

  it "Should react on object nulification" do
    country_1 = Country.find_by_name('Italy')
    city = City.create!(:name => 'Paris', :country_id => country_1.id)

    city.country = nil
    city.country_code == nil
  end
end

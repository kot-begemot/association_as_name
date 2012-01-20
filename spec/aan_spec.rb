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
    [[:country, 'Country', :name]]
  end

  validates :name, :presence => true
end

module Seeds
  def self.countries
    [{:name => 'Afghanistan',:iso_3166_a2 => 'AF'},
      {:name => 'Argentina',:iso_3166_a2 => 'AR'},
      {:name => 'Australia',:iso_3166_a2 => 'AU'},
      {:name => 'Austria',:iso_3166_a2 => 'AT'},
      {:name => 'Belgium',:iso_3166_a2 => 'BE'},
      {:name => 'Bolivia',:iso_3166_a2 => 'BO'},
      {:name => 'Bosnia and Herzegovina',:iso_3166_a2 => 'BA'},
      {:name => 'Bulgaria',:iso_3166_a2 => 'BG'},
      {:name => 'Chile',:iso_3166_a2 => 'CL'},
      {:name => 'China',:iso_3166_a2 => 'CN'},
      {:name => 'Cote d\'Ivoire',:iso_3166_a2 => 'CI'},
      {:name => 'Croatia',:iso_3166_a2 => 'HR'},
      {:name => 'Cuba',:iso_3166_a2 => 'CU'},
      {:name => 'Curacao',:iso_3166_a2 => 'CW'},
      {:name => 'Cyprus',:iso_3166_a2 => 'CY'},
      {:name => 'Czech Republic',:iso_3166_a2 => 'CZ'},
      {:name => 'Denmark',:iso_3166_a2 => 'DK'},
      {:name => 'Estonia',:iso_3166_a2 => 'EE'},
      {:name => 'Gibraltar',:iso_3166_a2 => 'GI'},
      {:name => 'Iran, Islamic Republic of',:iso_3166_a2 => 'IR'},
      {:name => 'Iraq',:iso_3166_a2 => 'IQ'},
      {:name => 'Ireland',:iso_3166_a2 => 'IE'},
      {:name => 'Italy',:iso_3166_a2 => 'IT'},
      {:name => 'Japan',:iso_3166_a2 => 'JP'},
      {:name => 'Kazakhstan',:iso_3166_a2 => 'KZ'},
      {:name => 'Latvia',:iso_3166_a2 => 'LV'},
      {:name => 'Luxembourg',:iso_3166_a2 => 'LU'},
      {:name => 'Mexico',:iso_3166_a2 => 'MX'},
      {:name => 'Nepal',:iso_3166_a2 => 'NP'},
      {:name => 'Nigeria',:iso_3166_a2 => 'NG'},
      {:name => 'Peru',:iso_3166_a2 => 'PE'},
      {:name => 'Romania',:iso_3166_a2 => 'RO'},
      {:name => 'Russian Federation',:iso_3166_a2 => 'RU'},
      {:name => 'Serbia',:iso_3166_a2 => 'RS'},
      {:name => 'Spain',:iso_3166_a2 => 'ES'},
      {:name => 'Swaziland',:iso_3166_a2 => 'SZ'},
      {:name => 'Sweden',:iso_3166_a2 => 'SE'},
      {:name => 'Switzerland',:iso_3166_a2 => 'CH'},
      {:name => 'Thailand',:iso_3166_a2 => 'TH'},
      {:name => 'Turkey',:iso_3166_a2 => 'TR'},
      {:name => 'Uganda',:iso_3166_a2 => 'UG'},
      {:name => 'Ukraine',:iso_3166_a2 => 'UA'},
      {:name => 'United Arab Emirates',:iso_3166_a2 => 'AE'},
      {:name => 'United Kingdom',:iso_3166_a2 => 'GB'},
      {:name => 'Venezuela',:iso_3166_a2 => 'VE'},].each {|c| Country.create!(c)}
  end
end

describe AAN do

  before(:each) do
    ActiveRecord::Base.connection.increment_open_transactions
    ActiveRecord::Base.connection.begin_db_transaction
    Seeds.countries
  end

  after(:each) do
    ActiveRecord::Base.connection.rollback_db_transaction
    ActiveRecord::Base.connection.decrement_open_transactions
  end

  it "should assign a correct association by name for existed object" do
    city = City.create!(:name => 'Roma')
    city.country_name = 'Italy'
    city.save

    city.country.should == Country.find_by_name('Italy')
    city.reload
    city.country.should == Country.find_by_name('Italy')
  end

  it "should not assign anything if record does not exists for existed object" do
    city = City.create!(:name => 'Roma')
    city.country_name = 'Country of OZ'
    city.save
    
    city.country.should be_nil
    city.reload
    city.country.should be_nil
  end

  it "should assign a correct association by name for new object" do
    city = City.create!(:name => 'Roma', :country_name => 'Italy')

    city.country.should == Country.find_by_name('Italy')
  end

  it "should not assign anything if record does not exists for new object" do
    city = City.create!(:name => 'Roma', :country_name => 'Country of OZ')
    
    city.country.should be_nil
    city.reload
    city.country.should be_nil
  end

  it "should assign a correct association" do
    country = Country.find_by_name('Italy')
    city = City.create!(:name => 'Roma')
    city.country = country
    city.save

    city.country.should == Country.find_by_name('Italy')
    city.country_name == 'Italy'
    city.reload
    city.country.should == Country.find_by_name('Italy')
    city.country_name == 'Italy'
  end
end
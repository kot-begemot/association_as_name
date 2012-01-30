require 'a_a_n/version'

module AAN
  autoload :AssociationAsName, 'a_a_n/association_as_name'
  autoload :Keeper, 'a_a_n/keeper'
end

ActiveRecord::Base.send :include, AAN::AssociationAsName
#
# Module that allows assing attributes by <tt>name</tt>(or any other method)
#
#  Example:
#
#    class UserProfile < ActiveRecord::StudetifyBase

#      acts_as_aan do
#        [ [:current_university, 'University', :name],
#          [:home_country, 'Country', :name]]
#      end
#
#      attr_accessible :home_country_name, :current_university_name
#
#      validates :home_country_name, :presence => true
#      validates :current_university_name, :presence => true
#    end
module AAN
  module AssociationAsName
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_aan &block
        AAN::Keeper.associations(self, &block)

        AAN::Keeper.structure[self].each_pair do |association, assoc_attrs|
          assoc_attrs.each do |structure|
            attribute = structure.first
            aliased_method = structure.last
            class_eval <<EOF
              # Could not use delegate for that, since attribute and aliased method could have different names
              def #{aliased_method}
                self.send(:#{association}).try(:#{attribute})
              end

              def #{aliased_method}=(value)
                self.send(:#{association}_id=, association(:#{association}).klass.find_by_#{attribute}(value).try(:id))
              end
EOF
          end
        end

      end
    end
  end
end

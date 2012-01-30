###
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
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_aan &block
        AAN::Keeper.associations(self, &block)

        AAN::Keeper.structure[self].each_pair do |association, assoc_attrs|
          assoc_attrs.each do |structure|
            attribute = structure.first
            aliased_method = structure.last
            class_eval <<EOF
              attr_accessor :#{aliased_method}
              before_validation :aan_set_#{association}
              after_initialize :aan_set_#{aliased_method}

              def #{aliased_method}
                @#{aliased_method} ||= #{association}.try(:#{attribute})
              end

              def #{association}_with_aan_assigment=(new_object)
                #{AAN::Keeper.nullify_aliased_methods_for self, association}
                association(:#{association}).replace(new_object)
              end
              alias_method_chain :#{association}=, :aan_assigment

              protected

              def aan_set_#{association}
                unless #{aliased_method}.blank?
                  obj = association(:#{association}).klass.find_by_#{attribute} #{aliased_method}
                  self.#{association} = obj unless obj.nil?
                end
              end

              def aan_set_#{aliased_method}
                unless #{aliased_method}.blank?
                  obj = association(:#{association}).klass.find_by_#{attribute} #{aliased_method}
                  self.#{association} = obj unless obj.nil?
                end
              end
EOF
          end
        end

      end
    end
  end
end

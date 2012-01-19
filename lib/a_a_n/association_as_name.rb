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
        aan_structure = block.call

        aan_structure.each do |aos|
          class_eval <<EOF
              attr_accessor :#{aos.first}_#{aos.last}
              before_validation :aan_set_#{aos.first}
              after_initialize :aan_set_#{aos.first}_#{aos.last}

              def #{aos.first}_#{aos.last}
                @#{aos.first}_#{aos.last} ||= #{aos.first}.try(:#{aos.last})
              end

              protected

              def aan_set_#{aos.first}
                unless #{aos.first}_#{aos.last}.blank?
                  obj = #{aos[1]}.find_by_#{aos.last} #{aos.first}_#{aos.last}
                  self.#{aos.first} = obj unless obj.nil?
                end
              end

              def aan_set_#{aos.first}_#{aos.last}
                unless #{aos.first}_#{aos.last}.blank?
                  obj = #{aos[1]}.find_by_#{aos.last} #{aos.first}_#{aos.last}
                  self.#{aos.first} = obj unless obj.nil?
                end
              end
EOF
        end

        class_eval <<EOF

            cattr_accessor :aan_structure
            @@aan_structure = #{aan_structure}
EOF
      end
    end
  end
end

module AAN
  class Keeper
    cattr_reader :current_model

    def self.nullify_aliased_methods_for model, assoc
      aliased_methods = []
      AAN::Keeper.aliases_for(model, assoc).each do |aliased_method|
        aliased_methods << "@#{aliased_method} = nil"
      end
      aliased_methods.join("\n")
    end

    def self.structure
      @@structures ||= {}
    end

    def self.[](*args)
      (structure[args.first] ||= {})
    end

    def self.associations model, &block
      @@current_model = model
      instance_eval &block
    end

    def self.association(name, &block)
      sub_structure = block.call
      sub_structure.each do |element|
        if element.is_a? Hash
          element.symbolize_keys!
          element = element.to_a.flatten
        elsif
          element = [element.to_sym, "#{name}_#{element}".to_sym]
        end
        (AAN::Keeper[current_model][name] ||= []) << element
      end
    end

    protected

    def self.aliases_for model, assoc
      structure[model][assoc].collect do |params|
        params.last
      end
    end

  end
end
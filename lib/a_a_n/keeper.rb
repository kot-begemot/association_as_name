module AAN
  class Keeper
    def self.nullify_aliased_methods_for assoc
      aliased_methods = []
      AAN::Keeper.aliases_for(assoc).each do |aliased_method|
        aliased_methods << "@#{aliased_method} = nil"
      end
      aliased_methods.join("\n")
    end

    def self.structure
      @structures ||= {}
    end

    def self.[](*args)
      (structure[args.first] ||= [])
    end
    
    def self.each
      structure.each do |sub_s|
        yield (sub_s)
      end
    end

    def self.associations &block
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
        AAN::Keeper[name] << element
      end
    end

    protected


    def self.aliases_for assoc
      structure[assoc].collect do |params|
        params.last
      end
    end

  end
end
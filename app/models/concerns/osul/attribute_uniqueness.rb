module Osul
  module AttributeUniqueness
    def attributes_with_uniqueness=(attributes_collection)
      relation = __callee__.to_s.gsub("_attributes=", "")
      if attributes_collection.is_a? Hash
        keys = attributes_collection.keys
        attributes_collection = if keys.include?('id') || keys.include?(:id)
          Array(attributes_collection)
        else
          attributes_collection.sort_by { |i, _| i.to_i }.map { |_, attributes| attributes }
        end
      end
      
      attributes_collection.each do |prop|
        search_prop = prop.except("_destroy")
        existing = self.send(relation).exists? search_prop
        # NOTE: if :id => "" (e.g. the item is new), this will be used as a search_prop, and will not be found
        # therefore, it will create a new object regardless. 
        next unless existing
        matching = self.class.reflect_on_association(relation).class_name.constantize.where(search_prop)
        selected = matching.each.select {|obj| obj.send(self.class.name.underscore).id == self.id }.first

        if self.send(relation).include? selected
          prop['id'] = selected.id if selected
        end
      end

      self.send(relation + "_attributes_without_uniqueness=", attributes_collection)
    end

  end
end
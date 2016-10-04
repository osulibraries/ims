module Osul
  class AdminPolicy < Hydra::AdminPolicy

    accepts_nested_attributes_for :default_permissions, allow_destroy: true
    

    # When changing a permission for an object/user, ensure an update is done, not a duplicate
      def default_permissions_attributes_with_uniqueness=(attributes_collection)
        if attributes_collection.is_a? Hash
          keys = attributes_collection.keys
          attributes_collection = if keys.include?('id') || keys.include?(:id)
            Array(attributes_collection)
          else
            attributes_collection.sort_by { |i, _| i.to_i }.map { |_, attributes| attributes }
          end
        end

        attributes_collection.each do |prop|
          existing = case prop[:type]
          when 'group'
            search_by_type(:group)
          when 'person'
            search_by_type(:person)
          end

          next unless existing
          selected = existing.find { |perm| perm.agent_name == prop[:name] }
          prop['id'] = selected.id if selected
        end

        self.default_permissions_attributes_without_uniqueness=attributes_collection
      end

    alias_method :default_permissions_attributes_without_uniqueness=, :default_permissions_attributes=
    alias_method :default_permissions_attributes=, :default_permissions_attributes_with_uniqueness=

    def search_by_type(type)
      case type
      when :group
        default_permissions.to_a.select { |p| group_agent?(p.agent) }
      when :person
        default_permissions.to_a.select { |p| person_agent?(p.agent) }
      end
    end

  end
end
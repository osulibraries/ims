module Hydra
  module Admin
    class Collection < ActiveFedora::Base

      include Hydra::Admin::CollectionBehavior
      # include Sufia::Noid
      # include CurationConcern::HumanReadableType
      include Sufia::GenericFile::Permissions

      belongs_to :admin_policy, predicate: ActiveFedora::RDF::ProjectHydra.isGovernedBy, class_name: "Osul::AdminPolicy"
      accepts_nested_attributes_for :admin_policy

      after_save :ensure_policy_includes_default_groups


      attr_accessor :creator

      def paranoid_permissions
        return true
        # TODO: make this work
        # super
      end

      def unit_changed?
        # Yes, this is an override. Original gives false positive when there was a change, but it's the exact same as the original value. 
        (unit_change.nil?)? false : self.unit_change.first != self.unit_change.last
      end

      def visibility_change_is_restrictive?
        restrictive = false
        if visibility_changed?
          restrictive = visibility != Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
        end
        return restrictive
      end

      def unset_members
        self.members.each do |member|
          #abort member.inspect
          member.collection_id = nil
          member.save
        end
      end

      def self.human_readable_type
        "Institutional Collection"
      end

      def terms_for_display
        []
      end

      def unit_group
        Osul::Group.find_by_key(unit)
      end

      def unit_display_name
        Osul::Group.find_by_key(unit).name
      end
      

      # Compute the sum of each file in the collection
      # Return an integer of the result
      def bytes
        members.reduce(0) { |sum, gf| sum + gf.file_size.first.to_i }
      end

      def ensure_policy_includes_default_groups

        groups = admin_policy.default_permissions.each.collect {|p| p.agent_name} rescue []
        additions = []
        additions = add_administrators_group(groups, additions)
        additions = add_unit_group(groups, additions)
        unless additions.empty?
          admin_policy.default_permissions_attributes = additions
          admin_policy.save
        end
      end

      def add_administrators_group(groups, additions)
        unless groups.include? "Administrators"
          additions << {type: "group", access: "edit", name: "Administrators"}
        end
        return additions
      end

      def add_unit_group(groups, additions)
        unless groups.include? unit
          additions << {type: "group", access: "edit", name: unit}
        end
        return additions
      end

    end
  end
end
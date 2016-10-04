# TODO: Actually hook this up as an object. Currently a term on GenericFile.
module Sufia
  module Forms
    module PreservationLevelsEditForm
      extend ActiveSupport::Concern

      module ClassMethods

        def build_permitted_params
          permitted = super
          permitted << { :preservation_level_attributes => [:value, :date_assigned, :id, :_destroy] }
          permitted
        end
        
        
      end

      # This is required so that fields_for will draw a nested form.
      # See ActionView::Helpers#nested_attributes_association?
      #   https://github.com/rails/rails/blob/a04c0619617118433db6e01b67d5d082eaaa0189/actionview/lib/action_view/helpers/form_helper.rb#L1890
      # def agents_attributes= attributes
      #   model.agents_attributes= attributes
      # end

      def preservation_level_attributes= attributes
        model.preservation_levels_attributes= attributes
      end
      

    end
  end
end
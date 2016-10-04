module Sufia
  module Forms
    module MaterialsEditForm
      extend ActiveSupport::Concern

      module ClassMethods

        def build_permitted_params
          permitted = super
          permitted << { :materials_attributes => [:material_type, :material, :id, :_destroy] }
          permitted
        end
        
      end

      # This is required so that fields_for will draw a nested form.
      # See ActionView::Helpers#nested_attributes_association?
      #   https://github.com/rails/rails/blob/a04c0619617118433db6e01b67d5d082eaaa0189/actionview/lib/action_view/helpers/form_helper.rb#L1890
      # def agents_attributes= attributes
      #   model.agents_attributes= attributes
      # end

      def materials_attributes= attributes
        model.materials_attributes= attributes
      end
        
      def material_terms
        [:material_type, :material]
      end
      

      
    end
  end
end
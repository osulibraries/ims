module Sufia
  module Forms
    module MeasurementsEditForm
      extend ActiveSupport::Concern

      module ClassMethods

        def build_permitted_params
          permitted = super
          permitted << { :measurements_attributes => [:measurement, :measurement_unit, :measurement_type, :id, :_destroy] }
          permitted
        end
        
      end

      # This is required so that fields_for will draw a nested form.
      # See ActionView::Helpers#nested_attributes_association?
      #   https://github.com/rails/rails/blob/a04c0619617118433db6e01b67d5d082eaaa0189/actionview/lib/action_view/helpers/form_helper.rb#L1890
      # def agents_attributes= attributes
      #   model.agents_attributes= attributes
      # end

      def measurements_attributes= attributes
        model.measurements_attributes= attributes
      end

      def measurement_terms
        [:measurement_unit, :measurement_type, :measurement]
      end
      
    end
  end
end

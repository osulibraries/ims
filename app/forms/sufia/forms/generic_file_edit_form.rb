module Sufia
  module Forms
    class GenericFileEditForm < GenericFilePresenter
      include HydraEditor::Form
      include HydraEditor::Form::Permissions
      include Sufia::Forms::MaterialsEditForm
      include Sufia::Forms::MeasurementsEditForm
      # include Sufia::Forms::PreservationLevelsEditForm

      self.required_fields = [:title, :resource_type, :collection_id]



      def self.build_permitted_params
        permitted = super
        permitted <<  :admin_policy_id
        permitted
      end

      def self.model_attributes(form_params)
        if form_params.nil?
          return []
        else
          super
        end
      end

      def self.reflect_on_association(association)
        ::GenericFile.reflect_on_association(association)
      end
    end
  end
end

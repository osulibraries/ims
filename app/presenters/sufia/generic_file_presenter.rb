module Sufia
  class GenericFilePresenter
    include Hydra::Presenter

    self.model_class = ::GenericFile
    # Terms is the list of fields displayed by app/views/generic_files/_show_descriptions.html.erb
    self.terms = [:resource_type, :title, :creator, :contributor, :abstract, :description, :bibliographic_citation, :tag,
       :rights, :provenance, :publisher, :date_created, :subject, :language, :identifier, :based_near, :related_url,
       :work_type, :spatial, :alternative, :temporal, :format, :staff_notes, :source, :part_of, :preservation_level_rationale,
       :preservation_level, :collection_identifier]


    # Depositor and permissions are not displayed in app/views/generic_files/_show_descriptions.html.erb
    # so don't include them in `terms'.
    delegate :depositor, :permissions, :materials, :measurements, :collection_id, to: :model

    def internal_only_terms
      [:staff_notes, :collection_identifier]
    end

    def tweeter
      user = ::User.find_by_user_key(model.depositor)
      if user.try(:twitter_handle).present?
        "@#{user.twitter_handle}"
      else
        I18n.translate('sufia.product_twitter_handle')
      end
    end

    # Add a schema.org itemtype
    def itemtype
      # Look up the first non-empty resource type value in a hash from the config
      Sufia.config.resource_types_to_schema[resource_type.to_a.reject { |type| type.empty? }.first] || 'http://schema.org/CreativeWork'
    rescue
      'http://schema.org/CreativeWork'
    end


  end
end

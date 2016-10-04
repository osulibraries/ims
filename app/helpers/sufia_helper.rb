module SufiaHelper
  include ::BlacklightHelper
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  def track_hydra_admin_collection_path(*args)
    track_solr_document_path(*args)
  end

  def url_for_document doc, options = {}
    if (doc.is_a?(SolrDocument) && doc.hydra_model == 'Collection')
      [collections, doc]
    elsif (doc.is_a?(SolrDocument) && doc.hydra_model == 'Hydra::Admin::Collection')  
      doc
    else
      [sufia, doc]
    end
  end

# on view=gallery search, this selects the thumbnail image.
  def sufia_thumbnail_tag(document, options)
    if (document.collection? || document.hydra_model == "Hydra::Admin::Collection")
        image_tag "site_images/collection-icon.svg"
    else
      super(document, options)
    end
  end

end

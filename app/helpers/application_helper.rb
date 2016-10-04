module ApplicationHelper
  # This is in the generic_file_helper, but is not showing up for some reason.

  def display_multiple value
    auto_link(value.join(" | "))
  end
  
  def convert_to_sym value
    return value if value.is_a? Symbol
    value.parameterize.underscore.to_sym
  end

  def display_non_image
    # This is similar to Sufia's generic_file_helper.rb download_image_tag method.
    if @generic_file.thumbnail.has_content?
      image_tag sufia.download_path(@generic_file, file: 'thumbnail'), class: "img-responsive", alt: "#{@generic_file.title.first}"
    else
      image_tag "default.png", alt: "No preview available", class: "img-responsive"
    end
  end

  def get_title_from_uri(uri)
    pid = uri.split("/").last
    solr_response, solr_doc = controller.get_solr_response_for_doc_id(pid)
    solr_doc['title_tesim'].first
  rescue => e
    logger.warn("WARN: Helper method get_name_from_uri raised an error when loading #{uri}.  Error was #{e}")
    return uri
  end

  def get_group_name_from_key(key)
    Osul::Group.units.each.select {|g| g.key.downcase == key }.first.name
  rescue => e
    logger.warn("WARN: Helper method get_group_name_from_key raised an error when loading #{key}.  Error was #{e}")
    return key
  end

  def bytes_from_solr(member_docs)
    docs = @member_docs.each.collect {|doc| JSON.parse(doc["object_profile_ssm"].first)}
    docs.reduce(0) { |sum, gf| sum + gf["file_size"].first.to_i }
  end

  def on_my_shares?
    params[:controller].match(/^my\/shares/)
  end

  def hidden_details?
    current_user.blank? || current_user.public?
  end

  def title_for(model, property = :name)
    model.send(property).presence || 'Untitled'
  end

end

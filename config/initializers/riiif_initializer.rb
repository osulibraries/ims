# Tell RIIIF to get files via HTTP (not from the local disk)
Riiif::Image.file_resolver = Riiif::HTTPFileResolver.new

if Rails.env == "development"
  #get fedora.yml config file where credentials are stored
  fedoraConfig = YAML.load_file("config/fedora.yml")["#{Rails.env}"]
  username = fedoraConfig["user"]
  password = fedoraConfig["password"]

  Riiif::Image.file_resolver.basic_auth_credentials = [username, password]
end 

# This tells RIIIF how to resolve the identifier to a URI in Fedora
DATASTREAM = 'imageContent'
Riiif::Image.file_resolver.id_to_uri = lambda do |id| 
  #id is being passed in with version label appended to it (for cache busting purposes in riiif). 
  #So we need to split it to retrieve the generic_file id
  generic_file_id = id.split('-')[0]
  file = GenericFile.find(generic_file_id)
  
  uri = file.content.uri
  if file.requires_watermark? 
    uri = file.low_resolution.uri
  end
  
  return uri
end


# In order to return the info.json endpoint, we have to have the full height and width of
# each image. If you are using hydra-file_characterization, you have the height & width 
# cached in Solr. The following block directs the info_service to return those values:
HEIGHT_SOLR_FIELD = 'height_isi'
WIDTH_SOLR_FIELD = 'width_isi'
Riiif::Image.info_service = lambda do |id, file|

  #id is being passed in with version label appended to it (for cache busting purposes in riiif). 
  #So we need to split it to retrieve the generic_file id
  generic_file_id = id.split('-')[0]
  file = GenericFile.find(generic_file_id)
  # @auth = {username: 'fedoraAdmin', password:'fedoraAdmin'}
  # options = {basic_auth: @auth}
  if file.characterization_terms.blank? or file.characterization_terms[:width].nil? or file.characterization_terms[:height].nil?
    width = 1500
    height = 1500
  else
    width = file.characterization_terms[:width][0].to_i
    height = file.characterization_terms[:height][0].to_i
  end

  { height: height, width: width }
end

# include Blacklight::SolrHelper
# def blacklight_config
#   CatalogController.blacklight_config
# end

### ActiveSupport::Benchmarkable (used in Blacklight::SolrHelper) depends on a logger method

def logger
  Rails.logger
end

if Rails.env == "production"
  Riiif::Image.file_resolver.cache_path = '/mnt/Fedora_NFS/ims_image_cache/production/'
end

Riiif::Engine.config.cache_duration_in_days = 30

# Riiif::not_found_image = 'imports/file2.jpg'

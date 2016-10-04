module Export
  class ExportBase
    attr_accessor :fedora_root_url 

    # during initialization either we feed in a root url, or we get it from config file
    def initialize(fedora_root_url=nil)
      @fedora_root_url = fedora_root_url || get_fedora_root_url 
    end

  private

    # Returns fedora url from config file
    def get_fedora_root_url
      require 'yaml'
      info = YAML::load(IO.read("./config/fedora.yml"))
      environment = Rails.env
      fedora_root_url = info[environment]["url"] + info[environment]["base_path"] + '/'
    end
    
  end
end

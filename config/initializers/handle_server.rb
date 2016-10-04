# Load the handle server configuration
Rails.application.config.x.handle = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'handle_server.yml'))).result)[Rails.env].with_indifferent_access

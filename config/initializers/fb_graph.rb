conf_file = File.join('config','facebook.yml')
facebook = YAML.load(File.read(conf_file))[Rails.env].with_indifferent_access
FBAuth = FbGraph::Auth.new(facebook[:app_id], facebook[:app_secret])

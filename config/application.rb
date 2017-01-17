require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Startapp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # config.i18n.load_path += Dir[Rails.root.join('config', 'locales','views','organizers' ,'events', '*.{rb,yml}')]
    # config.i18n.default_locale = :de
    config.assets.initialize_on_precompile = false

    config.paths.add "app/api", glob: "**/*.rb"
    config.autoload_paths += Dir["#{Rails.root}/app/api"]
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '/api/*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
        resource '/users/*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
      end
    end

    #redis-rails gem used this:
    #config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      "<div class=\"field_with_errors has-error\">#{html_tag}</div>".html_safe
    }

  end
end

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ParejasGame
  class Application < Rails::Application
    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :es
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0
    config.assets.paths << Rails.root.join("app/assets/images")

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

 
  end
end

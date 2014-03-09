Rabl.configure do |config|
  config.cache_all_output = true
  config.cache_sources = Rails.env.to_s != 'development' # Defaults to false
  config.view_paths = [Rails.root.join("app/views")]
end

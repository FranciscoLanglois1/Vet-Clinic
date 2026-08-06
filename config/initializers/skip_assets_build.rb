if Rails.env.test?
  # Deshabilitar cssbundling
  ENV["CSSBUNDLING_DISABLE"] = "true"
  ENV["JSBUNDLING_DISABLE"] = "true"
  ENV["SKIP_YARN"] = "true"
  ENV["SKIP_BUNDLE"] = "true"
  
  # Configuración de assets
  Rails.application.config.assets.enabled = false
  Rails.application.config.assets.compile = false
end

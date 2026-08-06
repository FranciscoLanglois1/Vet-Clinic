if Rails.env.test?
  Rails.application.config.assets.enabled = false
  Rails.application.config.assets.compile = false
  Rails.application.config.assets.skip_pipeline = true
  
  # Evitar que jsbundling se ejecute
  Rails.application.config.assets.precompile = []
end

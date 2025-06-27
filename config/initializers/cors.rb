Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # ou coloque a origem do seu frontend ex: 'http://localhost:3001'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: false
  end
end

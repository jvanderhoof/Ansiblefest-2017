require 'sinatra/base'

class FooApp < Sinatra::Application

  configure do
    set :bind, '0.0.0.0'
  end

  get '/' do
    "
      <h1>Welcome to Conjur Ops!</h1>
      <p>Environment: #{ENV['RACK_ENV']}</p>
      <p>Database Username: #{ENV['DB_USERNAME']}</p>
      <p>Database Password: #{ENV['DB_PASSWORD']}</p>
      <p>Stripe API Key: #{ENV['STRIPE_API_KEY']}</p>
    "
  end
end

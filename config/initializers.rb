# config/initializers.rb

require 'sinatra/base'

class MyApp < Sinatra::Base
  configure do
    set :bind, 'localhost'
    set :port, 3000
  end
end

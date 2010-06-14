# Rack-up config
require 'rubygems'
require 'rack/zetetic/campaign'
run Rack::Zetetic::Campaign.new('/path/to/your/campaigns.yml')

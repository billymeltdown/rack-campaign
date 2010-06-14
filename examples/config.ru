# Rack application

require 'rubygems'
require 'rack/zetetic/rack-campaign'

run Rack::Zetetic::CampaignLink.new('/path/to/your/campaigns.yml')

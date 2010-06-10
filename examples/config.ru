# Rack application

require 'rubygems'
require 'rack/zetetic/campaign_link'
# require File.join(File.dirname(__FILE__), 'lib', 'rack', 'zetetic', 'campaign_link')

run Rack::Zetetic::CampaignLink.new('/path/to/your/campaigns.yml')

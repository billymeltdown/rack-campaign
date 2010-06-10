require 'rubygems'
require File.join(File.dirname(__FILE__), 'lib', 'rack', 'zetetic', 'campaign_link')

use Rack::Zetetic::CampaignLink
run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['Hello there...'] ] }
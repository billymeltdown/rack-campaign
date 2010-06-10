require 'rubygems'
require 'rack'
require 'rack/request'
require 'rack/utils'
# require 'ruby-debug'

module Rack
  module Zetetic
    class CampaignLink
      
      UTM_VARS = { 
        'campaign' => 'utm_campaign',
        'source' => 'utm_source',
        'medium' => 'utm_medium',
        'term' => 'utm_term',
        'content' => 'utm_content'
      }
      
      attr_accessor :campaigns
      def campaigns
        @campaigns ||= {}
      end
      
      def initialize(app=nil, &block)
        @app = app
        @campaigns = open( 'campaigns.yml' ){ |yf| YAML::load( yf ) }
        yield self if block_given?
      end
      
      def call(env)
        # get a convenient request wrapper from Rack
        req = Rack::Request.new(env)
        id = req.path.split('/').last # take the last path piece as the campaign id        
        if c = @campaigns[id]
          # we've got a match!
          destination = c['url'] + '?'
          UTM_VARS.each do |key, utm_name|
            destination << "#{utm_name}=#{Rack::Utils.escape(c[key])}&"
          end
          
          [ 302, { 'Location' => destination, "Content-Type" => "text/plain" }, ['Redirecting...'] ]
        else
          # drop a 404 on the head!
          [ 404, {"Content-Type" => "text/plain"}, ['Page not found.']]
        end # if
      end # call
    end # CampaignLink
  end
end

# Rack::Handler::Mongrel.run Rack::Zetetic::CampaignLink.new, :Port => 9292
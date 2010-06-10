require 'rubygems'
require 'rack'
require 'rack/request'
require 'rack/utils'

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
      
      attr_accessor :campaign_file
      attr_accessor :campaigns
      def campaigns
        @campaigns ||= {}
      end
      
      def initialize *args
        @app = args.shift if args.first.respond_to? :call
        @campaign_file = args.shift
        @campaigns = open( @campaign_file ){ |yf| YAML::load( yf ) }
        yield self if block_given?
      end
      
      def call(env)
        # get a convenient request wrapper from Rack
        req = Rack::Request.new(env)
        id = req.path.split('/').last # take the last path piece as the campaign id        
        if campaign = @campaigns[id]
          # we've got a match!
          destination = campaign['url'] + '?'
          UTM_VARS.each do |key, utm_name|
            destination << "#{utm_name}=#{Rack::Utils.escape(campaign['tokens'][key])}&"
          end
          
          [ 302, { 'Location' => destination, "Content-Type" => "text/plain" }, ['Redirecting...'] ]
        else
          # drop a 404 on the head!
          [ 404, {'Content-Type' => 'text/html'}, ["Page not found"] ]
        end # if
      end # call
    end # CampaignLink
  end
end

# Rack::Handler::Mongrel.run Rack::Zetetic::CampaignLink.new, :Port => 9292
require File.dirname(__FILE__) + '/spec_helper'
require 'pp'
require 'ruby-debug'

describe "campaign" do
  
  CAMPAIGNS_FILE = File.dirname(__FILE__) + '/campaigns.yml'
  
  let(:campaigns) { File.open( CAMPAIGNS_FILE ){ |yf| YAML::load( yf ) } }
  let(:campaign_name) { campaigns.keys.first }
  let(:campaign) { campaigns[campaign_name] }
  let(:campaign_url) { campaigns[campaign_name]['url'] }
  
  def app
    @app ||= Rack::Builder.new do
      run Rack::Zetetic::Campaign.new( CAMPAIGNS_FILE )
    end
  end
  
  it "should match path to campaign and redirect" do
    get "/#{campaign_name}"
    last_response['Location'].should =~ /#{campaign_url}/
  end
  
  it "should match last path piece, ignoring the rest" do
    get "/foo/bar/baz/quux/#{campaign_name}"
    last_response['Location'].should =~ /#{campaign_url}/
  end
  
  it "should attach google utm variables to the redirect destination" do
    get "/#{campaign_name}"
    campaign['tokens'].keys.each do |key|
      expected_str = Regexp.escape( "utm_#{key}=#{ Rack::Utils.escape(campaign[key]) }" )
      last_response['Location'].should =~ /#{expected_str}/
    end
  end
  
  it "should 404 unmatched paths" do
    get "/foo/bar/baz"
    last_response.status.should eql(404)
  end
end
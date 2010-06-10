require 'yaml'

UTM_KEYS = [ :campaign, :source, :medium, :term, :content ]
campaigns = File.open( 'campaigns.yml' ){ |yf| YAML::load( yf ) }


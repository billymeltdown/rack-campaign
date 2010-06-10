# Unicorn-specific config
# unicorn -c /path/to/unicorn.rb -e production -D

app_dir = '/www/campaign_link'
worker_processes (ENV['RACK_ENV'] == 'production' ? 6 : 2)

# Restart any workers that haven't responded in 30 seconds 
timeout 30

# Load the Rack app into the master before forking workers
# for super-fast worker spawn times
preload_app true

# Listen on a Unix data socket
listen 'unix:' + app_dir + '/tmp/sockets/unicorn.sock', :backlog => 2048
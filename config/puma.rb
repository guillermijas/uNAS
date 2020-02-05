# frozen_string_literal: true

# Change to match your CPU core count
workers 1

# Min and Max threads per worker
threads 1, 4

port ENV.fetch('PORT') { 3000 }

# FOR NGINX ONLY

# shared_dir = '/tmp'
# bind "unix://#{shared_dir}/puma.sock"
# stdout_redirect "#{shared_dir}/puma.stdout.log",
#                 "#{shared_dir}/puma.stderr.log",
#                 true
# pidfile "#{shared_dir}/puma.pid"
# state_path "#{shared_dir}/puma.state"

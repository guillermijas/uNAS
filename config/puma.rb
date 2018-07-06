# Change to match your CPU core count
workers 1

# Min and Max threads per worker
threads 1, 4

shared_dir = '/tmp'

# Set up socket location
# bind "unix://#{shared_dir}/puma.sock"
bind 'tcp://0.0.0.0:3000'

# Logging
stdout_redirect "#{shared_dir}/puma.stdout.log",
                "#{shared_dir}/puma.stderr.log",
                true

# Set master PID and state locations
pidfile "#{shared_dir}/puma.pid"
state_path "#{shared_dir}/puma.state"
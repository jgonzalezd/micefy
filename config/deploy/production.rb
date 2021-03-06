# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{admin@162.209.108.20}
role :web, %w{admin@162.209.108.20}
role :db,  %w{admin@162.209.108.20}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '162.209.108.20', user: 'admin', roles: %w{web app db}, password: fetch(:password)

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

# deploy.rb or stage file (staging.rb, production.rb or else)
# set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, 'ruby-2.1.2@startapp'      # Defaults to: 'default'
# set :rvm_custom_path, '/home/admin/.rvm/'  # only needed if not detected
# set :unicorn_user, "admin"

set :rails_env, 'production'

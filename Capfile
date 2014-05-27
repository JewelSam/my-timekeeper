load 'deploy' if respond_to?(:namespace) # cap2 differentiator

load 'deploy/assets'

Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy'

require "rvm/capistrano"

default_run_options[:pty] = true
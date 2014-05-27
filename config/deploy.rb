
name = "application_name"

domain_name = 'site-domain.ru'


set :application, name

set :repository, "~/poligon/" + name


set :deploy_to, "/home/buzulukbz_deploy/sites/" + name

set :rvm_path, '/home/buzulukbz_deploy/.rvm/'

set :deploy_via, :copy
set :copy_exclude, [".svn", ".git"]

set :scm, "git"
#set :branch, "master"



set :user, "buzulukbz_deploy"

server "178.63.57.149", :app, :web, :db, :primary => true

set :use_sudo, false

namespace :deploy do
  desc "Restarting Passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"

  end

  desc "Upload file"
  task :upload_file do
    run "mkdir  -p #{shared_path}/public/ckeditor_assets"
    run "mkdir  -p #{shared_path}/system/dragonfly"
    top.upload("public/ckeditor_assets", "#{shared_path}/public/", :via=> :scp, :recursive => true)

    top.upload("public/system/dragonfly/development", "#{shared_path}/system/dragonfly/production", :via=> :scp, :recursive => true)

  end

  desc "Create init structure"
  task :first_setup do


    %x(cap deploy:setup)

    #run "rm -rf  #{shared_path}/db"
    #run "rm -rf  #{shared_path}/public"
    run "mkdir -p #{shared_path}/db"

    run "mkdir  -p #{shared_path}/public/ckeditor_assets"
    run "mkdir  -p #{shared_path}/system/dragonfly"




    top.upload("db/development.sqlite3", "#{shared_path}/db/production.sqlite3")

    %x(cap deploy:upload_file)

    %x(cap deploy:update_code)
    run "cd #{current_release} && bundle install"
    %x(cap deploy:create_symlink)

    #%x(cap deploy:change_host_file)
    #
    #%x(cap deploy)

  end

  desc "Change or create apache host file"
  task :change_host_file do
    #if domain_name.blank?
    #  domain_name = "#{name}.wlasowy.ru"
    #end


    host = "
    <VirtualHost 178.63.57.149:80>
      ServerName #{domain_name}
      DocumentRoot /home/buzulukbz_deploy/sites/#{name}/current/public


        <Directory /home/buzulukbz_deploy/sites/#{name}/current/public>
          AllowOverride all
          Options -MultiViews
        </Directory>

      CustomLog /home/buzulukbz_deploy/logs/#{name}.test.access.log combined
      ErrorLog /home/buzulukbz_deploy/logs/#{name}.test.error.log

      ServerAlias www.#{domain_name} #{name}.wlasowy.ru  www.#{name}.wlasowy.ru  #{name}.buzulukbz.info www.#{name}.buzulukbz.info
      ServerAdmin mrwlasow@gmail.com
    </VirtualHost>
    "

    config_contents = StringIO.new(host)
    top.upload(config_contents, "#{shared_path}/#{name}")
    sudo "sudo cp #{shared_path}/#{name} /etc/apache2/sites-available/#{name}"
    sudo "sudo a2ensite #{name}"
    sudo "sudo apache2ctl restart"
  end



  desc "Make symlink for database yaml"
  task :finalize_update do
    run "rm -r #{release_path}/public/ckeditor_assets"
    run "ln -nfs #{shared_path}/public/ckeditor_assets #{release_path}/public/ckeditor_assets"

    run "mkdir -p #{release_path}/public/system/dragonfly/"
    run "ln -nfs #{shared_path}/system/dragonfly/production #{release_path}/public/system/dragonfly/production"
    run "ln -nfs #{shared_path}/db/production.sqlite3 #{release_path}/db/production.sqlite3"
  end


  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end


end
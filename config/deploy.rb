
set :application, "design-east"
set :repository,  "git@github.com:CircuitLab/#{application}.git"
set :branch, "master"

set :user, "ubuntu"
set :use_sudo, false
set :deploy_to, "/home/#{user}/apps/#{application}"

set :scm, :git
set :scm_verbose, true
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

set :node_env, "production"
# set :node_port, 80
set :node_port, 8080
set :process_uid, user
set :process_env, "NODE_ENV=#{node_env} PORT=#{node_port} UID=#{process_uid}"

role :app, "133.242.21.89"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :default_environment, {
  'PATH' => "~/.nodebrew/current/bin:$PATH"
}

namespace :deploy do
  task :start, :roles => :app do
    run "#{process_env} forever start #{current_path}/index.js"
  end
  task :stop, :roles => :app do
    run "forever stop #{current_path}/index.js"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{process_env} forever restart #{current_path}/index.js"
  end
end

after "deploy:create_symlink", :roles => :app do
  run "ln -svf #{shared_path}/node_modules #{current_path}/node_modules"
  run "cd #{current_path} && npm i"
  run "cp -vf #{shared_path}/keys.json #{current_path}"
end

after "deploy:setup", :roles => :app do
  # timezone
  sudo "cp -fv /usr/share/zoneinfo/Japan /etc/localtime"
  
  # upgrade packages
  sudo "apt-get update"
  sudo "apt-get upgrade"
  
  # dependencies
  sudo "apt-get install build-essential"
  sudo "apt-get install git"
  
  # node
  run <<-EOM
    grep '.nodebrew/current/bin' ~/.bashrc \
      || curl -L git.io/nodebrew | perl - setup \
      && echo 'export PATH=$HOME/.nodebrew/current/bin:$PATH' >> ~/.bashrc
  EOM
  run ". ~/.bashrc"
  run "test -d .nodebrew/node/v0.10.17 || nodebrew install v0.10.17"
  run "nodebrew use v0.10.17"
  run "npm -g up"

  # mecab
  sudo "apt-get install mecab mecab-ipadic-utf8"
  
  # forever
  run "npm -g install forever"
  
  run "chmod o+x /home/#{user}"
  run "mkdir -p #{shared_path}/node_modules"  
end
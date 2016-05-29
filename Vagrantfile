# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

vagrant_root = File.dirname(File.expand_path(__FILE__))
conf = YAML.load_file("#{vagrant_root}/config/vagrant/config.yml")["default"]
project_folder = conf['project_folder'] || "#{conf['home_folder']}/#{conf['project_name']}"

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty32'
  config.vm.network 'forwarded_port', guest: 3000, host: 3000

  # requires plugin vbguest:
  ## vagrant plugin install vagrant-vbguest
  config.vbguest.auto_update = false

  config.vm.define conf['project_name']
  config.vm.provider 'virtualbox' do |vb|
    vb.name = conf['project_name']
    vb.memory = '1024'
  end

  config.vm.synced_folder '.', "/vagrant", disabled: true
  config.vm.synced_folder '.', project_folder

  env = {
    PROJECT_FOLDER: conf['project_folder'] || "#{conf['home_folder']}/#{conf['project_name']}",
    RUBY_VERSION: conf['ruby_version'],
    PG_VERSION: conf['pg_version']
  }

  config.vm.provision :file,  source: 'config/vagrant/ruby/rvm/gemrc',
                              destination: '/home/vagrant/.gemrc'

  config.vm.provision :shell, path: 'config/vagrant/system/setup',
                              env: env

  config.vm.provision :shell, path: 'config/vagrant/ruby/rvm/install',
                              privileged: false

  config.vm.provision :shell, path: 'config/vagrant/ruby/install',
                              privileged: false,
                              env: env

  config.vm.provision :shell, path: 'config/vagrant/postgresql/install',
                              env: env

  config.vm.provision :shell, path: 'config/vagrant/postgresql/setup',
                              env: env

  config.vm.provision :shell, path: 'config/vagrant/required_packages/install'

  config.vm.provision :shell, path: 'config/vagrant/rails/bundle',
                              privileged: false,
                              run: 'always',
                              env: env

  config.vm.provision :shell, path: 'config/vagrant/rails/setup',
                              privileged: false,
                              run: 'always',
                              env: env

  config.vm.provision :shell, path: 'config/vagrant/rails/server',
                              privileged: false,
                              run: 'always',
                              env: env
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

PROJECT_NAME = "flashcards"

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty32"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vbguest.auto_update = false

  config.vm.define PROJECT_NAME
  config.vm.provider "virtualbox" do |vb|
    vb.name = PROJECT_NAME
    vb.memory = "1024"
  end

  config.vm.provision :shell, path:   "config/vagrant/system/update"
  config.vm.provision :shell, path:   "config/vagrant/ruby/rvm/install",
                              privileged: false
  config.vm.provision :file,  source: "config/vagrant/ruby/rvm/gemrc",
                              destination: '/home/vagrant/.gemrc'
  config.vm.provision :shell, path:   "config/vagrant/ruby/install",
                              env: { RUBY_VERSION: '2.3.0' },
                              privileged: false
  config.vm.provision :shell, path:   "config/vagrant/postgresql/install"

  # TODO:
  #config.vm.provision :shell, path:   "config/vagrant/rails/required_packages/install"
  #config.vm.provision :shell, path:   "config/vagrant/rails/bundle",
  #                            privileged: false
  #config.vm.provision :shell, path:   "config/vagrant/rails/migrate",
  #                            privileged: false
  #config.vm.provision :shell, path:   "config/vagrant/rails/server",
  #                            privileged: false
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'.freeze

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'oauth2-provider-sequel'
  config.vm.box = 'debian/contrib-jessie64'

  # Configurate the virtual machine to use 3GB of RAM
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '3000']
  end

  # Sync folders
  config.vm.synced_folder '.', '/vagrant'

  # Run scripts
  config.vm.provision 'shell', path: 'vagrant.sh', env: ENV.to_h
end

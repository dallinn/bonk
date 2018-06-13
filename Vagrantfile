VAGRANTFILE_API_VERSION = "2"
require 'json'
if File.exists?(File.expand_path "./Vagrant.json")  
    settings = JSON.parse(File.read(File.expand_path "./Vagrant.json"))
end
local_path = settings['synced_folder_path'] 
private_network_ip = settings['private_network_ip']
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.boot_timeout = 600
  config.vm.box_url = "https://vagrantcloud.com/ubuntu/trusty64"
  # config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.provider :virtualbox do |vb|
    # vb.gui = true

    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # Usage docs: http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
    config.cache.auto_detect = true
    # config.cache.synced_folder_opts = {
    #     type: :nfs,
    #     mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    # }
  end
  
  config.vm.define "default", primary: true do |main|
    default_ports = {
      80   => 8000,
      443  => 44300,
      3306 => 33060,
      5432 => 54320,
      9200 => 9200,
      7654 => 7654,
      4040 => 4040,
      6379 => 63790
    }
    default_ports.each do |guest, host|
      
        config.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
      
    end

    main.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--cpus", 1]
        v.customize ["modifyvm", :id, "--memory", 1024]
        # v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        # v.customize ["modifyvm", :id, "--name", "devtest.test"]
      end

    main.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    main.ssh.forward_agent = false
    main.vm.hostname = 'devtest.test'
    main.vm.network :private_network, ip: private_network_ip
    # main.vm.synced_folder '/vagrant', '/home/vagrant/laravel', disabled: true

    main.vm.synced_folder local_path, "/home/vagrant/laravel" 
    # type: 'nfs', :nfs => true, mount_options: ['rw', 'tcp', 'fsc' ,'actimeo=2' 'dmode=775','fmode=664']
    # 
    main.vm.provision :shell, :path => "vagrant/scripts/main.sh"
    main.vm.provision :shell, :path => "vagrant/scripts/mysql.sh"
    main.vm.provision :shell, :path => "vagrant/scripts/webserver.sh"
    main.vm.provision :shell, :path => "vagrant/scripts/laravel.sh"
  end
	
end

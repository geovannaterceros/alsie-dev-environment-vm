# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = 'ubuntu/jammy64'
AGENT_IMAGE = 'generic/fedora35'
NODE_COUNT = 1

Vagrant.configure("2") do |config|
  config.vm.define "main" do |ciConfig|
    ciConfig.vm.box = BOX_IMAGE
    ciConfig.vm.hostname = 'dev-ci'
    ciConfig.vm.network :private_network, ip: "10.20.1.10"
    ciConfig.vm.network "forwarded_port", guest: 8080, host: 8080
    ciConfig.vm.provider :virtualbox do |vb|
      vb.gui = false
      vb.memory = "1024"
      vb.cpus = "1"
    end
    ciConfig.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y htop git openjdk-11-jdk-headless
    SHELL
  end 
  
  (1..NODE_COUNT).each do |i|
    config.vm.define "agent-#{1}" do |agentConfig|
      agentConfig.vm.box = AGENT_IMAGE
      agentConfig.vm.hostname = "agent-#{1}"
      agentConfig.vm.network :private_network, ip: "10.20.1.#{i + 10}"
      agentConfig.vm.synced_folder ".", "/vagrant"
      agentConfig.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.memory = "1024"
        vb.cpus = "1"
      end
      agentConfig.vm.provision "shell", inline: <<-SHELL
        dnf update -y
        dnf install -y htop git java-11-openjdk-headless
      SHELL
    end
  end

end

# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_IMAGE = 'ubuntu/jammy64'
AGENT_IMAGE = 'generic/fedora35'
NODE_COUNT = 2
BASE_NETWORK = '10.20.1'

Vagrant.configure("2") do |config|

  config.vagrant.plugins = [ 'vagrant-docker-compose' ]

  config.vm.define "main" do |ciConfig|
    ciConfig.vm.box = BOX_IMAGE
    ciConfig.vm.hostname = 'dev-ci'
    ciConfig.vm.network :private_network, ip: "#{BASE_NETWORK}.10"
    ciConfig.vm.network "forwarded_port", guest: 8080, host: 8080
    ciConfig.vm.provider :virtualbox do |vb|
      vb.gui = false
      vb.memory = "1024"
      vb.cpus = "1"
    end
    ciConfig.vm.provision "shell", inline: <<-SHELL
      # apt-get update
      apt-get install -y htop git openjdk-11-jdk-headless
    SHELL
    ciConfig.vm.provision :docker_compose, yml: "/vagrant/docker-compose.yml", run: "always"
  end

  (1..NODE_COUNT).each do |i|
    config.vm.define "agent-#{i}" do |agentConfig|
      agentConfig.vm.box = AGENT_IMAGE
      agentConfig.vm.hostname = "agent-#{i}"
      agentConfig.vm.network :private_network, ip: "#{BASE_NETWORK}.#{i + 10}"
      agentConfig.vm.synced_folder ".", "/vagrant"
      agentConfig.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.memory = "1024"
        vb.cpus = "1"
      end
      agentConfig.vm.provision "shell", name: 'agent_deps', inline: <<-SHELL
        # dnf update -y
        dnf install -y htop git java-11-openjdk-headless
      SHELL
      agentConfig.vm.provision :shell do |s|
        s.name = 'j_agent'
        s.env = {USER: 'jenkins', JENKINS_URL: "http://#{BASE_NETWORK}.10:8080", NPROCS: 1, USERNAME: 'user', PASSWORD: 'Control123'}
        s.path = 'provision-agent.sh'
      end
    end
  end

  config.vm.provision :docker
  config.vm.provision :shell do |s| 
    s.name = 'users'
    s.env = {USER: 'jenkins', KEY_NAME: 'vms-key'}
    s.path = "provision-users.sh"
  end

end

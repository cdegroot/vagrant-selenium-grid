# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "debsqueeze64"
  config.vm.box_url = "http://www.emken.biz/vagrant-boxes/debsqueeze64.box"


  config.vm.define "seleniumhub" do |senodehub|
    # 202 = 0xCA. Easy, eh?
    senodehub.vm.network :hostonly, "172.16.202.120"
    senodehub.vm.host_name = "senodehub.local"

    # Install Librarian-puppet first
    senodehub.vm.provision :shell, :path => "shell/main.sh"

    # Run puppet
    senodehub.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "sehub.pp"
      puppet.options = "--verbose --debug"
    end

    # Restart Selenium
    senodehub.vm.provision "shell",
      inline: "/etc/init.d/senode stop; /etc/init.d/sehub start; /etc/init.d/senode start"
  end
end

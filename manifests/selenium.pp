group { "puppet": ensure => "present" }

class selenium {
  # Required for staging module.
  package { "curl": ensure => present }
  package { "unzip": ensure => present }

  package { "openjdk-6-jre-headless": ensure => present }

  file { "/opt/selenium":
     ensure => directory,
  }

  file { "/opt/selenium/selenium-server-standalone.jar":
     require => File['/opt/selenium'],
     source => "/vagrant/files/selenium-server-standalone-2.33.0.jar",
  }
}

class sehub {
  require selenium

  file { "/etc/init.d/sehub":
      source => "/vagrant/files/sehub",
      owner => "root",
      mode => "0755",
  }

  service { "sehub":
    require => File['/etc/init.d/sehub'],
    enable => true,
    ensure => running,
  }
        
}

class senode {
  require selenium
  
  package { "iceweasel": ensure => present }
  package { "vnc4server": ensure => present }

  file { "/etc/init.d/senode":
      source => "/vagrant/files/senode",
      owner => "root",
      mode => "0755",
  }


  user { "senode":
    managehome => true,
    ensure => present,
    gid => senode
  }

  group { "senode":
    ensure => present,
  }

  service { "senode":
    require => [File['/etc/init.d/senode'], User['senode']],
    enable => true,
    ensure => running,
  }
        
  file { "/etc/init.d/senodevnc":
      source => "/vagrant/files/senodevnc",
      owner => "root",
      mode => "0755",
  }

  file { "/home/senode/.vnc":
    ensure => directory,
    owner => "senode",
    require => User['senode'],
  }

  file { "/home/senode/.vnc/passwd":
    source => "/vagrant/files/vnc/passwd",
    owner => "senode",
    group => "senode",
    mode => 0600,
    require => File['/home/senode/.vnc'],
  }

  file { "/home/senode/.vnc/xstartup":
    source => "/vagrant/files/vnc/xstartup",
    owner => "senode",
    require => File['/home/senode/.vnc'],
  }

  service { "senodevnc":
    require => [
       File['/etc/init.d/senode'], 
       File['/home/senode/.vnc/xstartup'],
       File['/home/senode/.vnc/passwd'],
       User['senode']
    ],
    enable => true,
    ensure => running,
  }

}


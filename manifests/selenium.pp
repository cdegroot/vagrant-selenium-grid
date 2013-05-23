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
     source => "/vagrant/files/opt/selenium/selenium-server-standalone-2.33.0.jar",
  }
}

class sehub {
  require selenium

  file { "/opt/selenium/sehub":
      source => "/vagrant/files/opt/selenium/sehub",
      owner => "root",
      mode => "0755",
  }

  file { "/etc/init.d/sehub":
      source => "/vagrant/files/etc/init.d/sehub",
      owner => "root",
      mode => "0755",
  }

  service { "sehub":
    require => [ 
        File['/etc/init.d/sehub'],
        File['/opt/selenium/sehub']
    ],
    enable => true,
    ensure => running,
  }
        
}

class senode {
  require selenium
  
  package { "iceweasel": ensure => present }
  package { "vnc4server": ensure => present }

  file { "/opt/selenium/senode":
      source => "/vagrant/files/opt/selenium/senode",
      owner => "root",
      mode => "0755",
  }

  file { "/etc/init.d/senode":
      source => "/vagrant/files/etc/init.d/senode",
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
    require => [ 
        User['senode'],
        File['/etc/init.d/senode'],
        File['/opt/selenium/senode']
    ],
    enable => true,
    ensure => running,
  }
        
  file { "/etc/init.d/senodevnc":
      source => "/vagrant/files/etc/init.d/senodevnc",
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
    mode => 0755,
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


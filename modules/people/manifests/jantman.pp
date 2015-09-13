class people::jantman {

  # begin modules from Puppetfile
  include brewcask
  include screen
  include chrome
  include spotify
  include emacs
  include wget

  # boxen/puppetlabs-libreoffice and all its forks are broken; do this here
  $libreoffice_version = '5.0.1'
  package { "LibreOffice-${libreoffice_version}":
    provider => 'appdmg',
    source   => "http://download.documentfoundation.org/libreoffice/stable/${libreoffice_version}/mac/x86_64/LibreOffice_${libreoffice_version}_MacOS_x86-64.dmg",
  }
  #package { 'LibreOffice-LanguagePack':
  #  provider => 'appdmg',
  #  source   => "http://download.documentfoundation.org/libreoffice/stable/${libreoffice_version}/mac/x86_64/LibreOffice_${libreoffice_version}_MacOS_x86-64_langpack_${locale}.dmg",
  #}

  class {'vagrant':
  }

  vagrant::plugin {'vagrant-host-shell': }
  vagrant::plugin {'vagrant-vbox-snapshot': }
  vagrant::plugin {'vagrant-vbguest': }
  vagrant::plugin {'vagrant-r10k': }

  include virtualbox

  include firefox
  include python
  # END modules from Puppetfile

  # apps
  package { 'skype':
    provider => 'brewcask',
    require  => Class['brewcask'],
  }

  # synergy
  file {'synergy.conf':
    ensure => present,
    path   => "/Users/${::boxen_user}/synergy.conf",
    source => "puppet:///modules/people/synergy.conf",
    owner  => $::boxen_user,
  }

  package {'synergy':
    provider => 'appdmg_eula',
    source   => 'https://s3-us-west-2.amazonaws.com/jantman-repo/osx/synergy-master-efd0108-MacOSX1010-x86_64.dmg',
  }

  # SSH server
  systemsetup::base {'systemsetup-setremotelogin':
    key   => 'remotelogin',
    value => true,
    type  => 'onoff',
  }
}

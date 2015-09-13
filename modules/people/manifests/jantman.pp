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

}

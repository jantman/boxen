class people::jantman {

  # begin modules from Puppetfile
  include brewcask
  include screen
  include chrome
  include spotify
  include emacs
  include wget

  #class { 'libreoffice':
  #  version => '5.0.1',
  #}

  #class { 'libreoffice::languagepack':
  #  version => '5.0.1',
  #  locale  => 'us',
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

class people::jantman {

  # begin modules from Puppetfile
  include brewcask
  include screen
  include chrome
  include spotify
  include emacs
  include wget
  include hipchat
  include mumble

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

  # OSX stuff
  # this next one throws errors on 10.10.3
  #osx::recovery_message { 'This Mac belongs to Jason Antman (jantman) jason@jasonantman.com 201-906-7347': }
  include osx::global::enable_keyboard_control_access
  include osx::global::expand_save_dialog
  include osx::finder::unhide_library
  include osx::finder::show_hidden_files
  include osx::finder::show_all_filename_extensions
  # disable "natural" scrolling
  class { 'osx::global::natural_mouse_scrolling':
    enabled => false
  }

  # we really want something nicer than an Exec here, but
  # https://github.com/glarizza/puppet-property_list_key/issues/4

  # set Pro terminal as default
  exec {'terminal_pro-startup':
    command => "/usr/libexec/PlistBuddy -c \"set :'Startup Window Settings' Pro\" /Users/${::boxen_user}/Library/Preferences/com.apple.Terminal.plist",
    onlyif  => "/usr/libexec/PlistBuddy -c \"print :'Startup Window Settings'\" /Users/${::boxen_user}/Library/Preferences/com.apple.Terminal.plist | grep -v Pro",
    user    => $::boxen_user,
  }

  exec {'terminal_pro-default':
    command => "/usr/libexec/PlistBuddy -c \"set :'Default Window Settings' Pro\" /Users/${::boxen_user}/Library/Preferences/com.apple.Terminal.plist",
    onlyif  => "/usr/libexec/PlistBuddy -c \"print :'Default Window Settings'\" /Users/${::boxen_user}/Library/Preferences/com.apple.Terminal.plist | grep -v Pro",
    user    => $::boxen_user,
  }

  # use Option as Meta key - Basic
  exec {'option_as_meta-basic':
    command => "/usr/libexec/PlistBuddy -c \"set :'Window Settings':Basic:useOptionAsMetaKey true\" /Users/${::boxen_user}/Library/Preferences/com.apple.Terminal.plist",
    onlyif  => "/usr/libexec/PlistBuddy -c \"print :'Window Settings':Basic:useOptionAsMetaKey\" /Users/${::boxen_user}/Library/Preferences/com.apple.Terminal.plist | grep -v true",
    user    => $::boxen_user,
  }

  # use Option as Meta key - Pro
  exec {'option_as_meta-pro':
    command => "/usr/libexec/PlistBuddy -c \"set :'Window Settings':Pro:useOptionAsMetaKey true\" /Users/${::boxen_user}/Library/Preferences/com.apple.Terminal.plist",
    onlyif  => "/usr/libexec/PlistBuddy -c \"print :'Window Settings':Pro:useOptionAsMetaKey\" /Users/${::boxen_user}/Library/Preferences/com.apple.Terminal.plist | grep -v true",
    user    => $::boxen_user,
  }

  # TODO - figure out how to set terminal keybindings in plist file
  # per <http://fplanque.com/dev/mac/mac-osx-terminal-page-up-down-home-end-of-line>

}

# A class for WP-CLI's plugin commands.
define wp::plugin (
  $location,
  $slug        = $title,
  $ensure      = enabled,
  $networkwide = false,
  $version     = 'latest',
  $all         = '',
  $skipdelete  = '',
  $unless      = undef,
  $user        = $::wp::user,
  $onlyif      = "${wp::params::bin_path}/wp core is-installed",
) {
  include wp::cli

  $network = $networkwide ? {
    true    => '--network',
    default => '',
  }

  $network_enabled = $networkwide ? {
    true    => '-network',
    default => '',
  }

  $held = $version ? {
    'latest' => '',
    default  => "--version=${version}"
  }

  if ( empty( $all ) ) {
    $delete_all_plugins = '--all'
  }

  if ( empty( $skipdelete ) ) {
    $skip_deleting_plugins = '--skip-delete'
  }

  case $ensure {
    activate: {
      $command = "activate ${slug} ${network}"
      $unless_check = "${wp::params::bin_path}/wp plugin is-active ${slug} ${network}"
    }
    enabled: {
      $command = "install ${slug} --activate${network_enabled} ${held}"
      $unless_check = "${wp::params::bin_path}/wp plugin is-active ${slug} ${network}"
    }
    disabled: {
      $command = "deactivate ${slug} ${network}"
    }
    installed: {
      $command = "install ${slug} ${held}"
      $unless_check = "${wp::params::bin_path}/wp plugin is-installed ${slug}"
    }
    deleted: {
      $command = "delete ${slug} ${delete_all_plugins}"
    }
    uninstalled: {
      $command = "uninstall ${slug} --deactivate ${skip_deleting_plugins}"
    }
    default: {
      fail('Invalid ensure argument passed into wp::plugin')
    }
  }

  wp::command { "${location} ${command}":
    location => $location,
    command  => "plugin ${command}",
    unless   => $unless_check,
    user     => $user,
    onlyif   => $onlyif,
  }
}

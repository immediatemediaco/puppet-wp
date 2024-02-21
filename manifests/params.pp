# A class for parameters we might need to use.
class wp::params {
  $user = $facts['os']['name'] ? {
    'windows' => undef,
    default   => 'www-data',
  }
  $bin_path = '/usr/local/bin'
  $executable_filename = $facts['os']['name'] ? {
    'windows' => 'wp.bat',
    default   => 'wp',
  }
  $php_package = $facts['os']['name'] ? {
    /^(Debian|Ubuntu)$/ => 'php5-cli',
    'windows'           => 'php',
    default             => 'php-cli',
  }
  $php_executable_path = $facts['os']['name'] ? {
    'windows' => 'C:/tools/php80/php.exe',
    default   => '/usr/bin/php',
  }
  $manage_php_package = true
  $manage_curl_package = true
  $manage_git_package = true
}

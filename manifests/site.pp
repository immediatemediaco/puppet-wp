# Create a type for "wp site" commands
define wp::site (
  $aliases,
  $location,
) {
  include wp::cli

  wp::site::create { $aliases:
    aliases  => $aliases,
    location => $location,
  }
}

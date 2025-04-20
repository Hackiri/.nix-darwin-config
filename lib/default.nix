# Custom library functions for your Nix configuration
{lib}: {
  # Example utility function to conditionally include a module if an input exists
  mkOptionalModule = input: module: lib.mkIf (input != null) module;

  # Add more utility functions here as needed
}

# This overlay fixes the types.string deprecation warning
final: prev: {
  # This overlay replaces any modules using types.string with lib.types.str
  lib =
    prev.lib
    // {
      types =
        prev.lib.types
        // {
          string = prev.lib.types.str;
        };
    };
}

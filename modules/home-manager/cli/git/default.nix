# Home Manager module for git configuration
_: {
  programs.gpg = {
    enable = true;
    settings = {
      trust-model = "tofu+pgp";
    };
  };

  programs.git = {
    enable = true;
    userName = "hackiri";
    userEmail = "128340174+Hackiri@users.noreply.github.com";
    signing = {
      signByDefault = true;
      key = "4291C3052F7415AA"; # Updated GPG key ID
    };
    extraConfig = {
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };
}

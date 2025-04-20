# Home Manager module for git configuration
{ ... }: {
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
      key = "6CE5860014793E29"; # Your GPG key ID
    };
    extraConfig = {
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };
}


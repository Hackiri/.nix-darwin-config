{
  config,
  lib,
  pkgs,
  ...
}: let
  zshDotDir = ".config/zsh";
  shellAliases = import ./aliases.nix;
in {
  home = {
    sessionVariables = {
      KREW_ROOT = "${config.home.homeDirectory}/.krew";
      PATH = "${config.home.homeDirectory}/.krew/bin:${config.home.homeDirectory}/bin:$PATH";
      GIT_USER_NAME = "hackiri";
      GIT_USER_EMAIL = "128340174+Hackiri@users.noreply.github.com";
      EDITOR = "vim";
      VISUAL = "vim";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      TERM = "xterm-256color";
      # oh-my-zsh configuration
      ZSH = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
      ZSH_CUSTOM = "${config.home.homeDirectory}/.oh-my-zsh/custom";
      ZSH_CACHE_DIR = "${config.home.homeDirectory}/.cache/oh-my-zsh";
    };

    packages = with pkgs; [
      direnv
      fzf
      zoxide
      bat
      jq
      oh-my-zsh
      python3Packages.pygments # Required for syntax highlighting
    ];
  };

  programs = {
    zsh = {
      enable = true;
      inherit shellAliases;
      enableCompletion = true;

      # Enable native plugins
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;

      history = {
        size = lib.mkForce 50000;
        save = lib.mkForce 50000;
        path = "${config.home.homeDirectory}/.zsh_history";
        ignoreDups = true;
        share = true;
        extended = true;
      };
      dotDir = zshDotDir;

      oh-my-zsh = {
        enable = true;
        package = pkgs.oh-my-zsh;
        theme = "jonathan";
        plugins = [
          "git"
          "sudo"
          "history"
          "direnv"
          "fzf"
          "zoxide"
          "z"
          "extract"
          "colored-man-pages"
          "command-not-found"
          "aliases"
          "alias-finder"
          "common-aliases"
          "copypath"
          "copyfile"
          "copybuffer"
          "dirhistory"
          "docker"
          "docker-compose"
          "kubectl"
          "npm"
          "pip"
          "python"
          "rust"
          "golang"
          "macos"
          "vscode"
          "web-search"
          "jsontools"
        ];
      };

      initExtra = ''
        # Ensure cache directory exists
        if [[ ! -d "$ZSH_CACHE_DIR" ]]; then
          mkdir -p "$ZSH_CACHE_DIR"
        fi

        # Source oh-my-zsh
        if [ -f "$ZSH/oh-my-zsh.sh" ]; then
          source "$ZSH/oh-my-zsh.sh"
        else
          echo "Warning: oh-my-zsh.sh not found at $ZSH/oh-my-zsh.sh"
        fi

        # Basic configurations
        zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
        WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

        # Fix for zle warnings
        zmodload zsh/zle
        zmodload zsh/zpty
        zmodload zsh/complete

        # Advanced ZSH options
        setopt AUTO_CD
        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS
        setopt PUSHD_MINUS
        setopt EXTENDED_HISTORY
        setopt HIST_EXPIRE_DUPS_FIRST
        setopt HIST_IGNORE_DUPS
        setopt HIST_IGNORE_SPACE
        setopt HIST_VERIFY
        setopt SHARE_HISTORY
        setopt INTERACTIVE_COMMENTS
        setopt COMPLETE_IN_WORD
        setopt ALWAYS_TO_END
        setopt PATH_DIRS
        setopt AUTO_MENU
        setopt AUTO_LIST
        setopt AUTO_PARAM_SLASH
        setopt NO_BEEP

        # Better directory navigation
        alias ..='cd ..'
        alias ...='cd ../..'
        alias ....='cd ../../..'
        alias .....='cd ../../../..'

        # Initialize zoxide
        eval "$(zoxide init zsh)"

        # FZF configuration
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_DEFAULT_OPTS="--height 50% -1 --layout=reverse --multi"
      '';

      profileExtra = ''
        if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
          . $HOME/.nix-profile/etc/profile.d/nix.sh
        fi
      '';
    };
  };
}

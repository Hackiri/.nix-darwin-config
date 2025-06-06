{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      # Configuration for direnv.toml
      warn_timeout = 5; # Warn if direnv takes more than 5 seconds to load
      strict_env = true; # More secure environment handling
      load_dotenv = true; # Load .env files automatically
    };

    stdlib = ''
      # Enhanced use_nix function with better caching
      use_nix() {
        local path="$(nix-instantiate --find-file nixpkgs)"
        if [ -f "${path}/.version-suffix" ]; then
          local version="$(< "$path/.version-suffix")"
        elif [ -f "${path}/.git/HEAD" ]; then
          local head="$(< "${path}/.git/HEAD")"
          local regex="^ref: (.*)$"
          if [[ "$head" =~ $regex ]]; then
            local ref="${BASH_REMATCH [1]}"
            local rev="$(< "${path}/.git/$ref")"
          else
            local rev="$head"
          fi
          local version="''${rev:0:7}"
        fi
        if [[ -n "$version" ]]; then
          watch_file nixpkgs-version
          echo "$version" > nixpkgs-version
          watch_file shell.nix
          watch_file default.nix
        fi
        if [ -f shell.nix ]; then
          use flake
        elif [ -f default.nix ]; then
          use flake
        fi
      }

      # Better flake support
      use_flake() {
        watch_file flake.nix
        watch_file flake.lock
        nix_direnv_watch_file flake.nix
        nix_direnv_watch_file flake.lock
        if ! has nix_direnv_version || ! nix_direnv_version 2.2.1; then
          log_status "\033[0;31mWarning: nix-direnv >= 2.2.1 is required to use use_flake\033[0m"
        fi
        local layout_dir=$(
          if [ -n "$XDG_CACHE_HOME" ]; then
            echo "$XDG_CACHE_HOME/direnv/layouts"
          else
            echo "$HOME/.cache/direnv/layouts"
          fi
        )
        mkdir -p "$layout_dir"
        local flake_path="."
        local attr="."
        local impure=""
        local extra_args=("--impure")
        local accept_flake_config=true

        eval "$("$direnv" stdlib)"

        # shellcheck disable=SC2034
        if nix flake info --json "$flake_path" 2>/dev/null | jq -e .url >/dev/null; then
          if [[ -n "$impure" ]]; then
            log_status "Using impure flake '$flake_path#$attr'"
          else
            log_status "Using pure flake '$flake_path#$attr'"
            extra_args=()
          fi
          if [[ "$accept_flake_config" == "true" ]]; then
            extra_args+=(--accept-flake-config)
          fi
          nix print-dev-env "''${extra_args[*]}" "$flake_path#$attr" > "$layout_dir/$direnv_layout_dir"
          watch_file "$layout_dir/$direnv_layout_dir"
          source "$layout_dir/$direnv_layout_dir"
        else
          log_error "Failed to evaluate flake from '$flake_path'"
          return 1
        fi
      }

      # Layout for Python Poetry projects
      layout_poetry() {
        if [[ ! -f pyproject.toml ]]; then
          log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
          return 1
        fi

        local VENV=$(poetry env info --path 2>/dev/null)
        if [[ -z $VENV || ! -d $VENV/bin ]]; then
          poetry install
          VENV=$(poetry env info --path)
        fi

        export VIRTUAL_ENV=$VENV
        export POETRY_ACTIVE=1
        PATH_add "$VENV/bin"
      }

      # Layout for Node.js projects
      layout_node() {
        if [[ ! -f package.json ]]; then
          log_error 'No package.json found'
          return 1
        fi

        local node_modules="$(pwd)/node_modules"
        PATH_add "$node_modules/.bin"
      }
    '';
  };
}

''
  # Function to change to system-config directory
  dots() {
    cd $HOME/.nix-darwin-config|| exit
  }

  # Function to save changes to system-config repository
  savedots() {
    echo " ::::::    Changing to ~/.nix-darwin-config   :::::: "
    local current_dir=$(pwd)  # Save the current directory
    cd ~/.nix-darwin-config|| exit

    echo " ::::::         Adding to Git        :::::: "
    local commit_message="$1"
    if [ -z "$commit_message" ]; then
      commit_message="Update system-config"
    fi
    local message=" :::::: Commit Message: $commit_message :::::: "
    echo "$message"

    local host_name=$(hostname)
    local host_message=":::::: Host:$host_name ::::::"
    echo "$host_message"
    local branch_name
    if [[ "$host_name" == "tars" ]]; then
      branch_name="tars"
    elif [[ "$host_name" == "master" ]]; then
      branch_name="master"
    else
      branch_name="main"
    fi
    local branch_message=":::::: Git-Branch:$branch_name ::::::"
    echo "$branch_message"

    git add .
    git commit -m "$commit_message"
    git push --set-upstream origin "$branch_name"

    echo " :::::: Changing back to current_dir :::::: "
    cd "$current_dir"  # Return to the original directory
  }

  # Function to rebuild nix-darwin configuration
  rebuild() {
    local hostname=$(hostname)
    local rebuild_message=" ::::::    Rebuilding nix-darwin configuration    :::::: "
    echo "$rebuild_message"
    darwin-rebuild switch --flake "$HOME/.nix-darwin-config/#$hostname"
  }

  # Function for git push with branch name
  gpush() {
    local branch="$1"
    if [ -z "$branch" ]; then
      branch=$(git symbolic-ref --short HEAD)
    fi
    git push origin "$branch"
  }

  # Function for git pull with branch name
  gpull() {
    local branch="$1"
    if [ -z "$branch" ]; then
      branch=$(git symbolic-ref --short HEAD)
    fi
    git pull origin "$branch"
  }

  # Function for nix flake update
  sfu() {
    local update_message=" ::::::    Updating nix flake    :::::: "
    echo "$update_message"
    nix flake update "$HOME/.nix-darwin-config"
  }

  # Function for nix garbage collection
  garbage() {
    local garbage_message=" ::::::    Running nix garbage collection    :::::: "
    echo "$garbage_message"
    nix-collect-garbage -d
    local optimise_message=" ::::::    Optimizing nix store    :::::: "
    echo "$optimise_message"
    nix store optimise
  }

  # Function to check home-manager news
  news() {
    home-manager news
  }
''

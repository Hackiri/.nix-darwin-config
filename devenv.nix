{pkgs, ...}: {
  packages = with pkgs; [
    # Python versions
    python310
    python311
    python312

    # Python tools
    poetry
    python311Packages.black
    python311Packages.ruff
    python311Packages.pytest

    # Development tools
    git
    gh
    neovim
    ripgrep
    fd
    fzf
    jq
    yq
    eza
  ];

  languages.python = {
    enable = true;
    package = pkgs.python312;
    poetry.enable = true;
  };

  env = {
    PYTHON_310 = "${pkgs.python310}/bin/python3";
    PYTHON_311 = "${pkgs.python311}/bin/python3";
    PYTHON_312 = "${pkgs.python312}/bin/python3";
  };

  enterShell = ''
    # Setup virtual environments
    for version in "3.10" "3.11"; do
      if [ ! -d "$PWD/.venv-$version" ]; then
        "PYTHON_''${version//./}" -m venv ".venv-$version"
        source ".venv-$version/bin/activate"
        pip install --upgrade pip poetry
        deactivate
      fi
    done

    # Helper functions
    py310() { source .venv-3.10/bin/activate; }
    py311() { source .venv-3.11/bin/activate; }
    py312() { poetry shell; }

    # Display environment info
    echo "🐍 Python Development Environment"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Available Python versions:"
    echo "  3.12 (default/poetry): $(python3 --version 2>&1)"
    echo "  3.11: $($PYTHON_311 --version 2>&1)"
    echo "  3.10: $($PYTHON_310 --version 2>&1)"
    echo ""
    echo "Commands:"
    echo "  py310  - Activate Python 3.10 environment"
    echo "  py311  - Activate Python 3.11 environment"
    echo "  py312  - Activate Python 3.12 poetry environment"
  '';
}

{
  description = "A flake for an agent simulation on the global brain algorithm";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # for `flake-utils.lib.eachSystem`
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ ];
          config = {
            allowUnfree = false;
            packageOverrides = super: let self = super.pkgs; in
            {
              rEnv = super.rWrapper.override {
                packages = with self.rPackages; [
                    shiny
                    shinydashboard
                    DBI
                    RSQLite
                    dplyr
                    tidyr
                    r2d3
                    languageserver
                ];
              };
              rstudioEnv = super.rstudioWrapper.override {
                packages = with self.rPackages; [
                    shiny
                    shinydashboard
                    DBI
                    RSQLite
                    dplyr
                    tidyr
                    r2d3
                ];
              };
            };
          };
        };
      in
      {
        devShells = {
          default = with pkgs; pkgs.mkShellNoCC {
            buildInputs = [
              just
              git
              cloc
              entr
              tldr
              litecli
              nodePackages.browser-sync
              process-compose
              julia-bin
              sqlite-interactive
              rstudioEnv
              rEnv
            ];
          };
        };
      }
    );
}



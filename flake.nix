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
              julia-bin
              sqlite-interactive
              rEnv
            ];
          };
        };
      }
    );
}



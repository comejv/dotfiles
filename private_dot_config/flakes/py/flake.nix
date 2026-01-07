{
  description = "Python dev environment with pylsp and black";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        pyPkgs = pkgs.python313Packages;
        pythonEnv = pkgs.python313.withPackages (
          ps: with ps; [
            matplotlib
            numpy
            pandas
            tabulate
            black
          ]
        );
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pythonEnv
            pkgs.pyright
            pkgs.virtualenv
          ];
        };
      }
    );
}

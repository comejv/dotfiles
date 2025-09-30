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
      in
      {
        # Dev shell with Python, pylsp, black
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.python313
            pkgs.virtualenv

            # Language server and tools
            pyPkgs.python-lsp-server
            pyPkgs.black
          ];
        };
      }
    );
}

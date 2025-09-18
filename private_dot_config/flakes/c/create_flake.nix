{
  description = "C development env: clangd, cmake-language-server, gcc, gdb";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
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
      in
      {
        devShells.default = pkgs.mkShell {
          # Core tools requested
          nativeBuildInputs = with pkgs; [
            gcc
            gdb
            clang-tools
            cmake-language-server
            bear # compile commands generator
          ];

        };
      }
    );
}

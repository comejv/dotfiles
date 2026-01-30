{
  description = "Raylib in C";

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
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            gcc
            gdb
            clang-tools
            cmake
            cmake-language-server
            bear
            pkg-config
          ];

          buildInputs = with pkgs; [
            libGL

            wayland
            wayland-protocols
            libxkbcommon

            raylib
          ];
        };
      }
    );
}

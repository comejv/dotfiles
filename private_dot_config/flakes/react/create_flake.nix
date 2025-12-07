{
  description = "React app development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_22
            nodePackages.typescript-language-server
            nodePackages.prettier
            tailwindcss-language-server
            vscode-langservers-extracted
          ];

          shellHook = ''
            echo "Node.js version: $(node --version)"
            echo "npm version: $(npm --version)"
          '';
        };
      }
    );
}

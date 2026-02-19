{
  description = "ESP-IDF with Node.js development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    esp-dev.url = "github:mirrexagon/nixpkgs-esp-dev";
  };

  outputs =
    {
      self,
      nixpkgs,
      esp-dev,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      esp-idf = esp-dev.devShells.${system}.esp-idf-full;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "esp-node-env";

        # This pulls in everything from the ESP-IDF flake's shell
        inputsFrom = [ esp-idf ];

        # This adds Node.js on top
        buildInputs = [
          pkgs.nodejs
          pkgs.cmake-language-server
        ];

        shellHook = ''
          ${esp-idf.shellHook or ""}
          export CMAKE_BUILD_PARALLEL_LEVEL="$(nproc)"
        '';
      };
    };
}

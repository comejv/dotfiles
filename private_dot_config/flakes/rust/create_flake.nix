{
  inputs = {
    nixpkgs.url = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
      rust = pkgs.rust-bin.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rustfmt"
          "clippy"
        ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          rust
          pkgs.rust-analyzer-unwrapped
          pkgs.pkg-config
          pkgs.gdb
          pkgs.ltrace
          pkgs.strace
          pkgs.valgrind
          pkgs.bats
          pkgs.check
        ];
        shellHook = ''
          export CARGO_HOME=$PWD/.cargo
        '';
      };
    };
}

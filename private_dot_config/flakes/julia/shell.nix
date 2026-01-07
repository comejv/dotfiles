{ pkgs ? import <nixpkgs> {} }:

let
  gccLib = pkgs.gcc.cc.lib;
  gfortranLib = pkgs.gccNGPackages_15.libgfortran;
in
pkgs.mkShell {
  packages = [
    pkgs.julia
    pkgs.python3
    pkgs.python3Packages.jupyter

    gccLib
    gfortranLib
  ];

  shellHook = ''
    export JULIA_DEPOT_PATH=$PWD/.julia
    export JUPYTER_DATA_DIR=$PWD/.jupyter

    export LD_LIBRARY_PATH=${gccLib}/lib:${gfortranLib}/lib:$LD_LIBRARY_PATH
  '';
}

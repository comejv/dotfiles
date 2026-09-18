{
  pkgs ? import <nixpkgs> { },
}:

let
  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      jupyter
      jupyterlab
      jupytext
      matplotlib
    ]
  );

  pySite = "${pythonEnv}/${pkgs.python3.sitePackages}";

  extraLibs = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc.lib
    pkgs.gfortran.cc.lib
    pkgs.nodejs
    pythonEnv
  ];
in
pkgs.mkShell {
  packages = [
    pkgs.julia
    pythonEnv
    pkgs.nodejs
  ];

  shellHook = ''
    set -e

    export JULIA_DEPOT_PATH="$PWD/.julia"
    export JULIA_PROJECT="$PWD"

    # Important for PyCall + nix pythonEnv:
    export PYTHON="${pythonEnv}/bin/python3"
    export PYTHONPATH="${pySite}:$PYTHONPATH"
    export PYTHONNOUSERSITE=1

    # Jupyter in-project (optional but helps reproducibility)
    export JUPYTER_CONFIG_DIR="$PWD/.jupyter"
    export JUPYTER_DATA_DIR="$PWD/.jupyter"
    export JUPYTER_RUNTIME_DIR="$PWD/.jupyter/runtime"

    export LD_LIBRARY_PATH="${extraLibs}:$LD_LIBRARY_PATH"
  '';
}

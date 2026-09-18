{
  pkgs ? import <nixpkgs> { },
}:

let
  pythonEnv = pkgs.python3.withPackages (
    ps: with ps; [
      jupyter
      jupytext
      matplotlib
      numpy
      scipy
      sympy
      black
    ]
  );

  pySite = "${pythonEnv}/${pkgs.python3.sitePackages}";
in
pkgs.mkShell {
  packages = [
    pythonEnv
    pkgs.nodejs
    pkgs.pyright
  ];

  shellHook = ''
    set -e

    export PYTHON="${pythonEnv}/bin/python3"
    export PYTHONPATH="${pySite}:$PYTHONPATH"
    export PYTHONNOUSERSITE=1

    # Jupyter in-project
    export JUPYTER_CONFIG_DIR="$PWD/.jupyter"
    export JUPYTER_DATA_DIR="$PWD/.jupyter"
    export JUPYTER_RUNTIME_DIR="$PWD/.jupyter/runtime"
  '';
}

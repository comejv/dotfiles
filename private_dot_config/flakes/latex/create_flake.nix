{
  description = "LaTeX development environment";

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

        custom-tex = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-small
            latexmk
            geometry
            microtype
            csquotes
            mathtools
            siunitx
            enumitem
            titlesec
            xcolor
            graphics
            kvoptions
            biblatex
            hyperref
            minted
            mlmodern
            ifthenx
            lastpage
            chngcntr
            caption
            algorithms
            algorithmicx
            ifoddpage
            relsize
            changepage
            beamer
            ;
        };

        pympress = pkgs.pympress.overrideAttrs (prev: {
          version = "1.8.5+e5da914";
          src = pkgs.fetchFromGitHub {
            owner = "Cimbali";
            repo = "pympress";
            rev = "e5da914ecb2f5beb6298225cde510e5ff07d02bc";
            sha256 = "sha256-9n/xfKwN85zqP/5wGjkRbjYo4q40yJE1ABmi40Fz9dk=";
          };
          buildInputs = prev.buildInputs ++ [ pkgs.python3Packages.babel ];
        });

        latexmkrc = pkgs.writeText "latexmkrc" ''
          # 1) Directory for all intermediate files
          $out_dir = 'build';
          ensure_path($out_dir);

          # 2) Produce PDF
          $pdf_mode = 1;

          # 3) pdfLaTeX command
          $pdflatex = 'pdflatex -interaction=nonstopmode '
                     . '-synctex=1 -halt-on-error '
                     . '-shell-escape '
                     . "-output-directory=$out_dir %O %S";

          # 4) Use Biber
          $bibtex_use = 2;
          $biber = "biber --input-directory=$out_dir "
                 . "--output-directory=$out_dir %O %B";

          # 5) Increase max runs
          $max_repeat = 10;
        '';

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # TeX distribution
            custom-tex

            # Language server and formatters
            texlab
            tex-fmt
            biber

            # Additional utilities
            python3
            python3Packages.pygments
            pympress
          ];
          shellHook = ''
            ln -sf ${latexmkrc} .latexmkrc
          '';
        };
      }
    );
}

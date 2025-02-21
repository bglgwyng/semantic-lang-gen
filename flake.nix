{
  description = "Tree-sitter binding generator for Haskell";

  nixConfig = {
    extra-substituters = [ "https://cache.iog.io" ];
    extra-trusted-public-keys =
      [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
  };

  inputs = {
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, haskellNix, ... }:
    let
      name = "tree-sitter-gen";
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          haskellNix.overlay
          (final: prev: {
            ${name} = final.haskell-nix.cabalProject'
              {
                src = ./.;
                compiler-nix-name = "ghc948";
                shell.tools = {
                  cabal = "latest";
                  haskell-language-server = "latest";
                  hlint = "latest";
                  # stylish-haskell = "latest차";
                  # hpack = "latest";
                };
                modules = [
                  {
                    packages = {
                      # 특정 패키지의 특정 버전 
                      # tree-sitter-foo2 = prev.haskellPackages.callCabal2nix "tree-sitter-foo" "${example-haskell-package}" { };
                    };
                  }
                ];
              };
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
          inherit (haskellNix) config;
        };
        flake = pkgs.${name}.flake { };
        example-parser = pkgs.callPackage ./nix/generate-parser.nix {
          inherit pkgs;
          name = "example-parser";
          grammar-js = ./example/grammar.js;
        };
        example-haskell-package = let name = "foo"; Name = "Foo"; in pkgs.stdenv.mkDerivation {
          name = "tree-sitter-example";
          # src = packages.example-parser;
          dontUnpack = true;
          buildPhase = ''
            mkdir vendor
            cp -r ${example-parser} vendor/tree-sitter-${name}
            cp ${./templates/tree-sitter-foo.cabal} tree-sitter-${name}.cabal
            substituteInPlace tree-sitter-${name}.cabal --replace foo ${name} --replace Foo ${Name}
            mkdir TreeSitter
            cp ${./templates/TreeSitter/Foo.hs} TreeSitter/${Name}.hs
            substituteInPlace TreeSitter/${Name}.hs --replace foo ${name} --replace Foo ${Name}
          '';
          installPhase = ''
            mkdir $out
            rm env-vars
            cp -r . $out/ 
            
          '';
        };
      in
      (flake // rec {
        packages.default = flake.packages."${name}:exe:app";
        devShells.default = flake.devShell.overrideAttrs (oldAttrs: {
          nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
            pkgs.tree-sitter
            pkgs.nodejs_22
          ];
        });

        # examples
        packages.example-parser = example-parser;
        packages.example-haskell-package = example-haskell-package;
        packages.example-haskell-package2 =
          pkgs.haskellPackages.callCabal2nix "tree-sitter-foo" "${example-haskell-package}" { };
      }));
}




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
                supportHpack = true;
                compiler-nix-name = "ghc948";
                shell.tools = {
                  cabal = "latest";
                  haskell-language-server = "latest";
                  hlint = "latest";
                  # stylish-haskell = "latest차";
                  # hpack = "latest";
                };
              };
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
          inherit (haskellNix) config;
        };
        flake = pkgs.${name}.flake { };
      in
      (flake // {
        packages.default = flake.packages."${name}:exe:app";
        devShells.default = flake.devShell.overrideAttrs (oldAttrs: {
          nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
            pkgs.tree-sitter
            pkgs.nodejs_22
          ];
        });
        generate-parser = grammar-js: pkgs.runCommand "generate-parser" { } ''
          ${pkgs.tree-sitter}/bin/tree-sitter generate ${grammar-js}
          cp dump.txt $out
        '';
        packages.example-parser = pkgs.callPackage ./nix/generate-parser.nix {
          inherit pkgs;
          name = "example-parser";
          grammar-js = ./example/grammar.js;
        };
      }));
}




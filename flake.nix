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
    tree-sitter.url = "github:bglgwyng/tree-sitter?ref=nix-abi-11";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      name = "tree-sitter-gen";
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        tree-sitter = inputs.tree-sitter.packages.${system}.default;
        pkgs = import nixpkgs {
          inherit system;
          config = { allowBroken = true; };
        };
      in
      ({
        packages.tree-sitter = pkgs.tree-sitter;
        packages.semantic-mini = (pkgs.haskellPackages.callCabal2nix "semantic-mini" ./semantic-mini { });
        semantic-mini = ./semantic-mini;
        generate-parser = pkgs.callPackage ./nix/generate-parser.nix { inherit tree-sitter; };
        generate-tree-sitter-lang = pkgs.callPackage ./nix/generate-tree-sitter-lang.nix;
        generate-semantic-lang = pkgs.callPackage ./nix/generate-semantic-lang.nix;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            tree-sitter
            pkgs.nodejs_22
          ];
        };
      }));
}




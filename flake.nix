{
  description = "Semantic language generation framework";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    haskell-flake.url = "github:srid/haskell-flake";
    haskell-tree-sitter = {
      url = "git+ssh://git@github.com/bglgwyng/haskell-tree-sitter?submodules=1";
      flake = false;
    };
    hypertypes = {
      url = "github:lamdu/hypertypes";
      flake = false;
    };
    th-abstraction = {
      url = "github:glguy/th-abstraction/v0.6.0.0";
      flake = false;
    };
  };

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      imports = [
        inputs.haskell-flake.flakeModule
      ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowBroken = true;
        };

        haskellProjects.default = {
          projectRoot = ./.;

          basePackages = pkgs.haskell.packages.ghc984;
          packages = {
            tree-sitter-arith.source = import ./nix/generate-tree-sitter-lang.nix
              {
                inherit pkgs;
                Lang = "Arith";
                parser = import ./nix/generate-parser.nix
                  {
                    inherit pkgs;
                    lang = "arith";
                    grammar-js = ./example/grammar.js;
                  };
                src-only = true;
              };
            tree-sitter.source = "${inputs.haskell-tree-sitter}/tree-sitter";
            hypertypes.source = inputs.hypertypes;
            th-abstraction.source = inputs.th-abstraction;
          };

          devShell = {
            hlsCheck.enable = false;
            tools = hpkgs: with hpkgs; {
              inherit cabal-fmt;
            };
            hoogle = true;
          };

          autoWire = [ "packages" ];
        };

        packages.tree-sitter = inputs'.tree-sitter.packages.default;

        devShells.default = pkgs.mkShell {
          inputsFrom = [
            config.haskellProjects.default.outputs.devShell
          ];
          nativeBuildInputs = with pkgs; [
            just
            nodejs_22
            tree-sitter
          ];
        };
      };

      flake = {
        # Export utility functions
        generate-parser = import ./nix/generate-parser.nix;
        generate-tree-sitter-lang = import ./nix/generate-tree-sitter-lang.nix;
        generate-semantic-lang = import ./nix/generate-semantic-lang.nix;
      };
    };
}

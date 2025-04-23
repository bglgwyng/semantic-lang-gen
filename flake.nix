{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    haskell-tree-sitter = {
      url = "git+ssh://git@github.com/bglgwyng/haskell-tree-sitter?submodules=1";
      flake = false;
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, withSystem, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.self.overlay
          ];
          config.allowBroken = true;
        };

        packages.tree-sitter = inputs'.tree-sitter.packages.default;

        devShells.default = pkgs.haskellPackages.shellFor {
          packages = hpkgs: [
            hpkgs.semantic-mini
          ];
          nativeBuildInputs = [
            pkgs.tree-sitter
            pkgs.nodejs_22
            pkgs.haskellPackages.haskell-language-server
          ];
        };
      };
      flake = {
        overlay = final: prev: {
          haskellPackages = prev.haskellPackages.override (_: {
            overrides = self: super: {
              semantic-mini = self.callCabal2nix "semantic-mini" ./semantic-mini { };
              tree-sitter = self.callCabal2nix "tree-sitter" "${inputs.haskell-tree-sitter}/tree-sitter" { };
            };
          });
        };
        # 
        generate-parser = import ./nix/generate-parser.nix;
        generate-tree-sitter-lang = import ./nix/generate-tree-sitter-lang.nix;
        generate-semantic-lang = import ./nix/generate-semantic-lang.nix;

        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}

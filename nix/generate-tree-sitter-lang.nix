{ pkgs, Lang, parser, src-only ? false }:
let
  lang = parser.lang;
  cabal = pkgs.writeText "tree-sitter-${lang}.cabal" ''
    cabal-version:       3.0
    name:                tree-sitter-${lang}
    version:             0.1.0.0
    description:         This package provides a parser for ${Lang} suitable for use with the tree-sitter package.

    data-files:          vendor/tree-sitter-${lang}/src/node-types.json

    common common
      default-language: Haskell2010
      ghc-options:
        -Weverything
        -Wno-all-missed-specialisations
        -Wno-implicit-prelude
        -Wno-missed-specialisations
        -Wno-missing-import-lists
        -Wno-missing-local-signatures
        -Wno-monomorphism-restriction
        -Wno-name-shadowing
        -Wno-safe
        -Wno-unsafe
      if (impl(ghc >= 8.6))
        ghc-options: -Wno-star-is-type
      if (impl(ghc >= 8.8))
        ghc-options: -Wno-missing-deriving-strategies
      if (impl(ghc >= 8.10))
        ghc-options:
          -Wno-missing-safe-haskell-mode
          -Wno-prepositive-qualified-module
      if (impl(ghc >= 9.2))
        ghc-options:
          -Wno-missing-kind-signatures
          -Wno-implicit-lift

    library
      import: common
      exposed-modules:     TreeSitter.${Lang}
      autogen-modules:     Paths_tree_sitter_${lang}
      other-modules:       Paths_tree_sitter_${lang}
      build-depends:       base
                         , tree-sitter
      Include-dirs:        vendor/tree-sitter-${lang}/src
      install-includes:    tree_sitter/parser.h
      extra-libraries:     stdc++
      c-sources:           vendor/tree-sitter-${lang}/src/parser.c${if parser.scanner-c == null then "" else ", vendor/tree-sitter-${lang}/src/scanner.c"}
  '';
  src = pkgs.stdenv.mkDerivation {
    name = "tree-sitter-${lang}";
    dontUnpack = true;
    buildPhase = ''
      mkdir vendor
      cp -r ${parser} vendor/tree-sitter-${lang}
      ln -s ${cabal} tree-sitter-${lang}.cabal
      mkdir TreeSitter
      cp ${../templates/tree-sitter-foo/TreeSitter/Foo.hs} TreeSitter/${Lang}.hs
      substituteInPlace TreeSitter/${Lang}.hs --replace foo ${lang} --replace Foo ${Lang}
    '';
    installPhase = ''
      rm env-vars
      mkdir $out
      cp -r . $out/ 
    '';
  };
in
if src-only then
  src
else
  (pkgs.haskellPackages.callCabal2nix "tree-sitter-${lang}" src { }).overrideAttrs (_: {
    inherit lang Lang parser;
  })
  

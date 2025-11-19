{ pkgs
, parser
, Lang
, lang ? parser.lang
, cabal-package-name ? "tree-sitter-${lang}"
, src-only ? false
}:
let
  cabal_package_name = builtins.replaceStrings [ "-" ] [ "_" ] cabal-package-name;
  cabal = pkgs.writeText "${cabal-package-name}.cabal" ''
    cabal-version:       3.0
    name:                ${cabal-package-name}
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
      autogen-modules:     Paths_${cabal_package_name}
      other-modules:       Paths_${cabal_package_name}
      build-depends:       base
                         , tree-sitter
      Include-dirs:        vendor/tree-sitter-${lang}/src
      install-includes:    tree_sitter/parser.h
      extra-libraries:     stdc++
      c-sources:           vendor/tree-sitter-${lang}/src/parser.c${if parser.scanner-c == null then "" else ", vendor/tree-sitter-${lang}/src/scanner.c"}
  '';
  Lang-hs = pkgs.writeText "${Lang}.hs" ''
    module TreeSitter.${Lang} (
      tree_sitter_${lang},
      getNodeTypesPath,
    ) where

    import Foreign.Ptr
    import Paths_${cabal_package_name}
    import TreeSitter.Language

    foreign import ccall unsafe "vendor/tree-sitter-${lang}/src/parser.c tree_sitter_${parser.lang}" tree_sitter_${lang} :: Ptr Language

    getNodeTypesPath :: IO FilePath
    getNodeTypesPath = getDataFileName "vendor/tree-sitter-${lang}/src/node-types.json"
  '';
  src = pkgs.stdenv.mkDerivation {
    name = "tree-sitter-${lang}";
    dontUnpack = true;
    buildPhase = ''
      mkdir vendor
      cp -r ${parser} vendor/tree-sitter-${lang}
      ln -s ${cabal} tree-sitter-${lang}.cabal
      mkdir TreeSitter
      ln -s ${Lang-hs} TreeSitter/${Lang}.hs
    '';
    installPhase = ''
      rm env-vars
      mkdir $out
      cp -r . $out/ 
    '';
  };
in
src

{ pkgs, lang, grammar-js }:
pkgs.stdenv.mkDerivation {
  inherit lang;
  name = "tree-sitter-${lang}";
  src = grammar-js;
  nativeBuildInputs = [ pkgs.tree-sitter pkgs.nodejs_22 ];
  dontUnpack = true;
  # why tmp is needed?
  buildPhase = ''
    mkdir tmp
    cd tmp
    tree-sitter generate --prev-abi $src
  '';
  installPhase = ''
    mkdir -p $out
    cp -r ./* $out
  '';
  postInstall = ''
    mkdir -p $out/etc
    mv $out/env-vars $out/etc/
  '';
}

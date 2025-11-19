{ pkgs, lang, grammar-js, scanner-c ? null }:
pkgs.stdenv.mkDerivation {
  inherit lang scanner-c;
  name = "tree-sitter-${lang}";
  src = grammar-js;
  nativeBuildInputs = [ pkgs.tree-sitter pkgs.nodejs_22 ];
  dontUnpack = true;
  # why tmp is needed?
  buildPhase = ''
    mkdir tmp
    cd tmp
    tree-sitter generate --abi 14 $src
    ${if scanner-c == null then "" else "ln -s ${scanner-c} src/scanner.c"}
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

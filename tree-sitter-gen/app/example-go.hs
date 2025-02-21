{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

import AST.Unmarshal (parseByteString)
import TreeSitter.Go
import Language.Go.AST

main :: IO ()
main = do
    let source =
            "package main\n"
                <> "import \"fmt\"\n"
                <> "func main() {  \n}"
    typedAst <- parseByteString @SourceFile @() tree_sitter_go source
    print typedAst
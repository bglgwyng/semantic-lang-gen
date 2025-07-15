{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

import AST.Element
import AST.Unmarshal
import Language.Arith.AST
import TreeSitter.Arith

main :: IO ()
main = do
  let source = "x * (y + 1)"

  typedAst <- parseByteString @SourceFile @() tree_sitter_arith source

  print typedAst

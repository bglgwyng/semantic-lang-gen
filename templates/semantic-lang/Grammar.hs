{-# LANGUAGE TemplateHaskell #-}

module Language.Foo.Grammar (
  tree_sitter_foo,
  Grammar (..),
) where

import AST.Grammar.TH
import Language.Haskell.TH
import TreeSitter.Foo (tree_sitter_foo)

-- | Statically-known rules corresponding to symbols in the grammar.
mkStaticallyKnownRuleGrammarData (mkName "Grammar") tree_sitter_foo

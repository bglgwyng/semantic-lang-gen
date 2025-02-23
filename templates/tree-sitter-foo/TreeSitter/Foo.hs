module TreeSitter.Foo (
  tree_sitter_foo,
  getNodeTypesPath,
  -- , getTestCorpusDir
) where

import Foreign.Ptr
import Paths_tree_sitter_foo
import TreeSitter.Language

foreign import ccall unsafe "vendor/tree-sitter-foo/src/parser.c tree_sitter_foo" tree_sitter_foo :: Ptr Language

getNodeTypesPath :: IO FilePath
getNodeTypesPath = getDataFileName "vendor/tree-sitter-foo/src/node-types.json"

-- getTestCorpusDir :: IO FilePath
-- getTestCorpusDir = getDataFileName "vendor/tree-sitter-foo/test/corpus"
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeApplications #-}

module Main (main) where

import AST.Unmarshal (parseByteString)
import Control.Monad
import Foreign.C.String
import Foreign.Marshal.Alloc (malloc)
import Foreign.Marshal.Array (mallocArray)
import Foreign.Ptr (
    Ptr,
    nullPtr,
 )
import Foreign.Storable (
    peek,
    peekElemOff,
    poke,
 )
import Language.Go.AST
import TreeSitter.Go
import TreeSitter.Node
import TreeSitter.Parser
import TreeSitter.Tree

main :: IO ()
main = do
    parser <- ts_parser_new

    _ <- ts_parser_set_language parser tree_sitter_go
    let source =
            "package main\n"
                ++ "import \"fmt\"\n"
                ++ "func main() {\n"
                ++ "    fmt.Println(\"hello world\")\n"
                ++ "}"
    let source2 =
            "package main\n"
                <> "import \"fmt\"\n"
                <> "func main() {  \n}"
    -- <>
    -- "    fmt.Println()\n" <>
    -- "}\n"
    x <- parseByteString @SourceFile @() tree_sitter_go source2
    -- case x of
    --   SourceFile {..} -> do
    --     putStrLn "module (root) ------------"
    --   _ -> putStrLn "not a source file"
    print x
    (str, len) <- newCStringLen source
    tree <- ts_parser_parse_string parser nullPtr str len

    n <- malloc
    ts_tree_root_node_p tree n

    putStrLn "module (root) ------------"
    Node{..} <- peek n -- header, imports, and declarations
    let childCount = fromIntegral nodeChildCount

    children <- mallocArray childCount
    tsNode <- malloc
    poke tsNode nodeTSNode
    ts_node_copy_child_nodes tsNode children

    printChildren children childCount

    putStrLn "declarations ------------"
    Node{..} <- peekElemOff children 2 -- declarations: bind and bind
    let nextChildCount = fromIntegral nodeChildCount

    nextChildren <- mallocArray nextChildCount
    nextTsNode <- malloc
    poke nextTsNode nodeTSNode
    ts_node_copy_child_nodes nextTsNode nextChildren

    printChildren nextChildren nextChildCount

    putStrLn "END"

printChildren :: Ptr Node -> Int -> IO ()
printChildren children count =
    forM_
        [0 .. count - 1]
        ( \n -> do
            child <- peekElemOff children n
            printNode child
        )

printNode :: Node -> IO ()
printNode n@(Node{..}) = do
    theType <- peekCString nodeType
    let TSPoint{..} = nodeStartPoint n
        start = "(" ++ show pointRow ++ "," ++ show pointColumn ++ ")"
    let TSPoint{..} = nodeEndPoint
        end = "(" ++ show pointRow ++ "," ++ show pointColumn ++ ")"
    putStrLn $ theType ++ start ++ "-" ++ end

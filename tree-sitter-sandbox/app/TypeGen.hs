module TypeGen where

import Control.Monad (forM)
import Data.Aeson
import Data.ByteString.Lazy qualified as BS
import Data.Maybe (catMaybes)
import Data.Text qualified as T

data NodeType = NodeType
    { name :: T.Text
    , kind :: T.Text
    , named :: Bool
    , fields :: Maybe [(T.Text, T.Text)]
    }
    deriving (Show)

instance FromJSON NodeType where
    parseJSON = withObject "NodeType" $ \v ->
        NodeType
            <$> v .: "type"
            <*> v .: "kind"
            <*> v .: "named"
            <*> v .:? "fields"

generateHaskellTypes :: FilePath -> FilePath -> IO ()
generateHaskellTypes grammarFile nodeTypesFile = do
    nodeTypesJson <- BS.readFile nodeTypesFile
    case eitherDecode nodeTypesJson of
        Left err -> putStrLn $ "Error parsing node-types.json: " ++ err
        Right nodeTypes -> do
            let haskellTypes = map nodeTypeToHaskell nodeTypes
            writeFile "GeneratedTypes.hs" $
                unlines
                    [ "{-# LANGUAGE OverloadedStrings #-}"
                    , "module GeneratedTypes where"
                    , ""
                    , "import qualified Data.Text as T"
                    , ""
                    , unlines haskellTypes
                    ]

nodeTypeToHaskell :: NodeType -> String
nodeTypeToHaskell nt =
    "data "
        ++ T.unpack (name nt)
        ++ " = "
        ++ T.unpack (name nt)
        ++ case fields nt of
            Nothing -> ""
            Just fs -> " { " ++ fieldsToHaskell fs ++ " }"
        ++ " deriving (Show, Eq)"

fieldsToHaskell :: [(T.Text, T.Text)] -> String
fieldsToHaskell = unwords . map (\(name, typ) -> T.unpack name ++ " :: " ++ T.unpack typ ++ ",")

main :: IO ()
main = generateHaskellTypes "grammar.json" "node-types.json"

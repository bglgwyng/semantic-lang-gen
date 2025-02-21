{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE TypeOperators #-}

module AST.Grammar.Examples () where

import AST.Token
import AST.Unmarshal
import Control.Effect.Reader
import Control.Monad.Fail
import Data.ByteString qualified as B
import Data.Text qualified as Text
import Data.Text.Encoding qualified as Text
import GHC.Generics (Generic1, (:+:))
import Numeric (readDec)
import Source.Range
import Prelude hiding (fail)

-- | An example of a sum-of-products datatype.
newtype Expr a = Expr ((If :+: Block :+: Var :+: Lit :+: Bin) a)
    deriving (Generic1, Unmarshal)

instance SymbolMatching Expr where
    matchedSymbols _ = []
    showFailure _ _ = ""

-- | Product with multiple fields.
data If a = If {ann :: a, condition :: Expr a, consequence :: Expr a, alternative :: Maybe (Expr a)}
    deriving (Generic1, Unmarshal)

instance SymbolMatching If where
    matchedSymbols _ = []
    showFailure _ _ = ""

-- | Single-field product.
data Block a = Block {ann :: a, body :: [Expr a]}
    deriving (Generic1, Unmarshal)

instance SymbolMatching Block where
    matchedSymbols _ = []
    showFailure _ _ = ""

-- | Leaf node.
data Var a = Var {ann :: a, text :: Text.Text}
    deriving (Generic1, Unmarshal)

instance SymbolMatching Var where
    matchedSymbols _ = []
    showFailure _ _ = ""

-- | Custom leaf node.
data Lit a = Lit {ann :: a, lit :: IntegerLit}
    deriving (Generic1, Unmarshal)

instance SymbolMatching Lit where
    matchedSymbols _ = []
    showFailure _ _ = ""

-- | Product with anonymous sum field.
data Bin a = Bin {ann :: a, lhs :: Expr a, op :: (AnonPlus :+: AnonTimes) a, rhs :: Expr a}
    deriving (Generic1, Unmarshal)

instance SymbolMatching Bin where
    matchedSymbols _ = []
    showFailure _ _ = ""

-- | Anonymous leaf node.
type AnonPlus = Token "+" 0

-- | Anonymous leaf node.
type AnonTimes = Token "*" 1

newtype IntegerLit = IntegerLit Integer

instance UnmarshalAnn IntegerLit where
    unmarshalAnn node = do
        Range start end <- unmarshalAnn node
        bytestring <- asks source
        let drop = B.drop start
            take = B.take (end - start)
            slice = take . drop
            str = Text.unpack (Text.decodeUtf8 (slice bytestring))
        case readDec str of
            (i, _) : _ -> pure (IntegerLit i)
            _ -> fail ("could not parse '" <> str <> "'")

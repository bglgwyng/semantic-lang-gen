{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuantifiedConstraints #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

module Language.Go.AST (module Language.Go.AST) where

import AST.Parse qualified
import AST.Token qualified
import AST.Traversable1.Class qualified
import AST.Unmarshal qualified
import Data.Foldable qualified
import Data.List qualified as Data.OldList
import Data.Maybe qualified as GHC.Maybe
import Data.Text.Internal qualified
import Data.Traversable qualified
import GHC.Base qualified
import GHC.Generics qualified
import GHC.Records qualified
import GHC.Show qualified
import TreeSitter.Node qualified
import Prelude qualified as GHC.Classes

debugSymbolNames :: [GHC.Base.String]
debugSymbolNames = debugSymbolNames_0

debugSymbolNames_0 :: [GHC.Base.String]
debugSymbolNames_0 =
    [ "end"
    , "identifier"
    , "_\n"
    , "_;"
    , "_package"
    , "_import"
    , "_."
    , "blank_identifier"
    , "_("
    , "_)"
    , "_const"
    , "_,"
    , "_="
    , "_var"
    , "_func"
    , "_..."
    , "_type"
    , "_*"
    , "_["
    , "_]"
    , "_struct"
    , "_{"
    , "_}"
    , "_interface"
    , "_map"
    , "_chan"
    , "_<-"
    , "_:="
    , "_++"
    , "_--"
    , "_*="
    , "_/="
    , "_%="
    , "_<<="
    , "_>>="
    , "_&="
    , "_&^="
    , "_+="
    , "_-="
    , "_|="
    , "_^="
    , "_:"
    , "_fallthrough"
    , "_break"
    , "_continue"
    , "_goto"
    , "_return"
    , "_go"
    , "_defer"
    , "_if"
    , "_else"
    , "_for"
    , "_range"
    , "_switch"
    , "_case"
    , "_default"
    , "_select"
    , "identifier"
    , "identifier"
    , "_+"
    , "_-"
    , "_!"
    , "_^"
    , "_&"
    , "_/"
    , "_%"
    , "_<<"
    , "_>>"
    , "_&^"
    , "_|"
    , "_=="
    , "_!="
    , "_<"
    , "_<="
    , "_>"
    , "_>="
    , "_&&"
    , "_||"
    , "raw_string_literal"
    , "_\""
    , "_interpreted_string_literal_token1"
    , "escape_sequence"
    , "int_literal"
    , "float_literal"
    , "imaginary_literal"
    , "rune_literal"
    , "nil"
    , "true"
    , "false"
    , "comment"
    , "source_file"
    , "package_clause"
    , "import_declaration"
    , "import_spec"
    , "dot"
    , "import_spec_list"
    , "_declaration"
    , "const_declaration"
    , "const_spec"
    , "var_declaration"
    , "var_spec"
    , "function_declaration"
    , "method_declaration"
    , "parameter_list"
    , "parameter_declaration"
    , "variadic_parameter_declaration"
    , "type_alias"
    , "type_declaration"
    , "type_spec"
    , "expression_list"
    , "parenthesized_type"
    , "_simple_type"
    , "pointer_type"
    , "array_type"
    , "implicit_length_array_type"
    , "slice_type"
    , "struct_type"
    , "field_declaration_list"
    , "field_declaration"
    , "interface_type"
    , "method_spec_list"
    , "method_spec"
    , "map_type"
    , "channel_type"
    , "function_type"
    , "block"
    , "_statement_list"
    , "_statement"
    , "empty_statement"
    , "_simple_statement"
    , "send_statement"
    , "receive_statement"
    , "inc_statement"
    , "dec_statement"
    , "assignment_statement"
    , "short_var_declaration"
    , "labeled_statement"
    , "labeled_statement"
    , "fallthrough_statement"
    , "break_statement"
    , "continue_statement"
    , "goto_statement"
    , "return_statement"
    , "go_statement"
    , "defer_statement"
    , "if_statement"
    , "for_statement"
    , "for_clause"
    , "range_clause"
    , "expression_switch_statement"
    , "expression_case"
    , "default_case"
    , "type_switch_statement"
    , "_type_switch_header"
    , "type_case"
    , "select_statement"
    , "communication_case"
    , "_expression"
    , "parenthesized_expression"
    , "call_expression"
    , "variadic_argument"
    , "argument_list"
    , "argument_list"
    , "selector_expression"
    , "index_expression"
    , "slice_expression"
    , "type_assertion_expression"
    , "type_conversion_expression"
    , "composite_literal"
    , "literal_value"
    , "keyed_element"
    , "element"
    , "func_literal"
    , "unary_expression"
    , "binary_expression"
    , "qualified_type"
    , "interpreted_string_literal"
    , "_source_file_repeat1"
    , "_import_spec_list_repeat1"
    , "_const_declaration_repeat1"
    , "_const_spec_repeat1"
    , "_var_declaration_repeat1"
    , "_parameter_list_repeat1"
    , "_type_declaration_repeat1"
    , "_field_name_list_repeat1"
    , "_expression_list_repeat1"
    , "_field_declaration_list_repeat1"
    , "_method_spec_list_repeat1"
    , "__statement_list_repeat1"
    , "_expression_switch_statement_repeat1"
    , "_type_switch_statement_repeat1"
    , "_type_case_repeat1"
    , "_select_statement_repeat1"
    , "_argument_list_repeat1"
    , "_literal_value_repeat1"
    , "_interpreted_string_literal_repeat1"
    , "field_identifier"
    , "label_name"
    , "package_identifier"
    , "type_identifier"
    ]
newtype Expression a = Expression {getExpression :: ((BinaryExpression GHC.Generics.:+: CallExpression GHC.Generics.:+: CompositeLiteral GHC.Generics.:+: False GHC.Generics.:+: FloatLiteral GHC.Generics.:+: FuncLiteral GHC.Generics.:+: Identifier GHC.Generics.:+: ImaginaryLiteral GHC.Generics.:+: IndexExpression GHC.Generics.:+: IntLiteral GHC.Generics.:+: InterpretedStringLiteral GHC.Generics.:+: Iota GHC.Generics.:+: Nil GHC.Generics.:+: ParenthesizedExpression GHC.Generics.:+: RawStringLiteral GHC.Generics.:+: RuneLiteral GHC.Generics.:+: SelectorExpression GHC.Generics.:+: SliceExpression GHC.Generics.:+: True GHC.Generics.:+: TypeAssertionExpression GHC.Generics.:+: TypeConversionExpression GHC.Generics.:+: TypeInstantiationExpression GHC.Generics.:+: UnaryExpression) a)}
    deriving newtype (AST.Unmarshal.SymbolMatching)
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_1.
          AST.Traversable1.Class.Traversable1 a_1
        )
instance GHC.Records.HasField "ann" (Expression a_2) a_2 where
    getField = AST.Unmarshal.gann GHC.Base.. getExpression
deriving instance (GHC.Classes.Eq a_3) => GHC.Classes.Eq (Expression a_3)
deriving instance (GHC.Classes.Ord a_4) => GHC.Classes.Ord (Expression a_4)
deriving instance (GHC.Show.Show a_5) => GHC.Show.Show (Expression a_5)
instance AST.Unmarshal.Unmarshal Expression
instance Data.Foldable.Foldable Expression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor Expression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable Expression where
    traverse = AST.Traversable1.Class.traverseDefault1
newtype SimpleStatement a = SimpleStatement {getSimpleStatement :: ((AssignmentStatement GHC.Generics.:+: DecStatement GHC.Generics.:+: ExpressionStatement GHC.Generics.:+: IncStatement GHC.Generics.:+: SendStatement GHC.Generics.:+: ShortVarDeclaration) a)}
    deriving newtype (AST.Unmarshal.SymbolMatching)
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_6.
          AST.Traversable1.Class.Traversable1 a_6
        )
instance GHC.Records.HasField "ann" (SimpleStatement a_7) a_7 where
    getField = AST.Unmarshal.gann GHC.Base.. getSimpleStatement
deriving instance (GHC.Classes.Eq a_8) => GHC.Classes.Eq (SimpleStatement a_8)
deriving instance (GHC.Classes.Ord a_9) => GHC.Classes.Ord (SimpleStatement a_9)
deriving instance (GHC.Show.Show a_10) => GHC.Show.Show (SimpleStatement a_10)
instance AST.Unmarshal.Unmarshal SimpleStatement
instance Data.Foldable.Foldable SimpleStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor SimpleStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable SimpleStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
newtype SimpleType a = SimpleType {getSimpleType :: ((ArrayType GHC.Generics.:+: ChannelType GHC.Generics.:+: FunctionType GHC.Generics.:+: GenericType GHC.Generics.:+: InterfaceType GHC.Generics.:+: MapType GHC.Generics.:+: NegatedType GHC.Generics.:+: PointerType GHC.Generics.:+: QualifiedType GHC.Generics.:+: SliceType GHC.Generics.:+: StructType GHC.Generics.:+: TypeIdentifier) a)}
    deriving newtype (AST.Unmarshal.SymbolMatching)
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_11.
          AST.Traversable1.Class.Traversable1 a_11
        )
instance GHC.Records.HasField "ann" (SimpleType a_12) a_12 where
    getField = AST.Unmarshal.gann GHC.Base.. getSimpleType
deriving instance (GHC.Classes.Eq a_13) => GHC.Classes.Eq (SimpleType a_13)
deriving instance (GHC.Classes.Ord a_14) => GHC.Classes.Ord (SimpleType a_14)
deriving instance (GHC.Show.Show a_15) => GHC.Show.Show (SimpleType a_15)
instance AST.Unmarshal.Unmarshal SimpleType
instance Data.Foldable.Foldable SimpleType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor SimpleType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable SimpleType where
    traverse = AST.Traversable1.Class.traverseDefault1
newtype Statement a = Statement {getStatement :: ((SimpleStatement GHC.Generics.:+: Block GHC.Generics.:+: BreakStatement GHC.Generics.:+: ConstDeclaration GHC.Generics.:+: ContinueStatement GHC.Generics.:+: DeferStatement GHC.Generics.:+: EmptyStatement GHC.Generics.:+: ExpressionSwitchStatement GHC.Generics.:+: FallthroughStatement GHC.Generics.:+: ForStatement GHC.Generics.:+: GoStatement GHC.Generics.:+: GotoStatement GHC.Generics.:+: IfStatement GHC.Generics.:+: LabeledStatement GHC.Generics.:+: ReturnStatement GHC.Generics.:+: SelectStatement GHC.Generics.:+: TypeDeclaration GHC.Generics.:+: TypeSwitchStatement GHC.Generics.:+: VarDeclaration) a)}
    deriving newtype (AST.Unmarshal.SymbolMatching)
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_16.
          AST.Traversable1.Class.Traversable1 a_16
        )
instance GHC.Records.HasField "ann" (Statement a_17) a_17 where
    getField = AST.Unmarshal.gann GHC.Base.. getStatement
deriving instance (GHC.Classes.Eq a_18) => GHC.Classes.Eq (Statement a_18)
deriving instance (GHC.Classes.Ord a_19) => GHC.Classes.Ord (Statement a_19)
deriving instance (GHC.Show.Show a_20) => GHC.Show.Show (Statement a_20)
instance AST.Unmarshal.Unmarshal Statement
instance Data.Foldable.Foldable Statement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor Statement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable Statement where
    traverse = AST.Traversable1.Class.traverseDefault1
newtype Type a = Type {getType :: ((SimpleType GHC.Generics.:+: ParenthesizedType) a)}
    deriving newtype (AST.Unmarshal.SymbolMatching)
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_21.
          AST.Traversable1.Class.Traversable1 a_21
        )
instance GHC.Records.HasField "ann" (Type a_22) a_22 where
    getField = AST.Unmarshal.gann GHC.Base.. getType
deriving instance (GHC.Classes.Eq a_23) => GHC.Classes.Eq (Type a_23)
deriving instance (GHC.Classes.Ord a_24) => GHC.Classes.Ord (Type a_24)
deriving instance (GHC.Show.Show a_25) => GHC.Show.Show (Type a_25)
instance AST.Unmarshal.Unmarshal Type
instance Data.Foldable.Foldable Type where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor Type where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable Type where
    traverse = AST.Traversable1.Class.traverseDefault1
data ArgumentList a = ArgumentList
    { ann :: a
    , extraChildren :: ([AST.Parse.Err ((Expression GHC.Generics.:+: Type GHC.Generics.:+: VariadicArgument) a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_26.
          AST.Traversable1.Class.Traversable1 a_26
        )
instance AST.Unmarshal.SymbolMatching ArgumentList where
    matchedSymbols _ = [161, 162]
    showFailure _ node_27 =
        "expected "
            GHC.Base.<> ( "argument_list, argument_list"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_27 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_27) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_28 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_29 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_30 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_31 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_28
            c1_29 = TreeSitter.Node.nodeStartPoint node_27
        TreeSitter.Node.TSPoint
            r2_30
            c2_31 = TreeSitter.Node.nodeEndPoint node_27
deriving instance (GHC.Classes.Eq a_32) => GHC.Classes.Eq (ArgumentList a_32)
deriving instance (GHC.Classes.Ord a_33) => GHC.Classes.Ord (ArgumentList a_33)
deriving instance (GHC.Show.Show a_34) => GHC.Show.Show (ArgumentList a_34)
instance AST.Unmarshal.Unmarshal ArgumentList
instance Data.Foldable.Foldable ArgumentList where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ArgumentList where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ArgumentList where
    traverse = AST.Traversable1.Class.traverseDefault1
data ArrayType a = ArrayType
    { ann :: a
    , length :: (AST.Parse.Err (Expression a))
    , element :: (AST.Parse.Err (Type a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_35.
          AST.Traversable1.Class.Traversable1 a_35
        )
instance AST.Unmarshal.SymbolMatching ArrayType where
    matchedSymbols _ = [113]
    showFailure _ node_36 =
        "expected "
            GHC.Base.<> ( "array_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_36 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_36) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_37 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_38 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_39 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_40 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_37
            c1_38 = TreeSitter.Node.nodeStartPoint node_36
        TreeSitter.Node.TSPoint
            r2_39
            c2_40 = TreeSitter.Node.nodeEndPoint node_36
deriving instance (GHC.Classes.Eq a_41) => GHC.Classes.Eq (ArrayType a_41)
deriving instance (GHC.Classes.Ord a_42) => GHC.Classes.Ord (ArrayType a_42)
deriving instance (GHC.Show.Show a_43) => GHC.Show.Show (ArrayType a_43)
instance AST.Unmarshal.Unmarshal ArrayType
instance Data.Foldable.Foldable ArrayType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ArrayType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ArrayType where
    traverse = AST.Traversable1.Class.traverseDefault1
data AssignmentStatement a = AssignmentStatement
    { ann :: a
    , left :: (AST.Parse.Err (ExpressionList a))
    , right :: (AST.Parse.Err (ExpressionList a))
    , operator :: (AST.Parse.Err ((AnonymousPercentEqual GHC.Generics.:+: AnonymousAmpersandEqual GHC.Generics.:+: AnonymousAmpersandCaretEqual GHC.Generics.:+: AnonymousStarEqual GHC.Generics.:+: AnonymousPlusEqual GHC.Generics.:+: AnonymousMinusEqual GHC.Generics.:+: AnonymousSlashEqual GHC.Generics.:+: AnonymousLAngleLAngleEqual GHC.Generics.:+: AnonymousEqual GHC.Generics.:+: AnonymousRAngleRAngleEqual GHC.Generics.:+: AnonymousCaretEqual GHC.Generics.:+: AnonymousPipeEqual) a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_44.
          AST.Traversable1.Class.Traversable1 a_44
        )
instance AST.Unmarshal.SymbolMatching AssignmentStatement where
    matchedSymbols _ = [134]
    showFailure _ node_45 =
        "expected "
            GHC.Base.<> ( "assignment_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_45 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_45) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_46 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_47 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_48 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_49 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_46
            c1_47 = TreeSitter.Node.nodeStartPoint node_45
        TreeSitter.Node.TSPoint
            r2_48
            c2_49 = TreeSitter.Node.nodeEndPoint node_45
deriving instance (GHC.Classes.Eq a_50) => GHC.Classes.Eq (AssignmentStatement a_50)
deriving instance (GHC.Classes.Ord a_51) => GHC.Classes.Ord (AssignmentStatement a_51)
deriving instance (GHC.Show.Show a_52) => GHC.Show.Show (AssignmentStatement a_52)
instance AST.Unmarshal.Unmarshal AssignmentStatement
instance Data.Foldable.Foldable AssignmentStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor AssignmentStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable AssignmentStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data BinaryExpression a = BinaryExpression
    { ann :: a
    , left :: (AST.Parse.Err (Expression a))
    , right :: (AST.Parse.Err (Expression a))
    , operator :: (AST.Parse.Err ((AnonymousBangEqual GHC.Generics.:+: AnonymousPercent GHC.Generics.:+: AnonymousAmpersand GHC.Generics.:+: AnonymousAmpersandAmpersand GHC.Generics.:+: AnonymousAmpersandCaret GHC.Generics.:+: AnonymousStar GHC.Generics.:+: AnonymousPlus GHC.Generics.:+: AnonymousMinus GHC.Generics.:+: AnonymousSlash GHC.Generics.:+: AnonymousLAngle GHC.Generics.:+: AnonymousLAngleLAngle GHC.Generics.:+: AnonymousLAngleEqual GHC.Generics.:+: AnonymousEqualEqual GHC.Generics.:+: AnonymousRAngle GHC.Generics.:+: AnonymousRAngleEqual GHC.Generics.:+: AnonymousRAngleRAngle GHC.Generics.:+: AnonymousCaret GHC.Generics.:+: AnonymousPipe GHC.Generics.:+: AnonymousPipePipe) a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_53.
          AST.Traversable1.Class.Traversable1 a_53
        )
instance AST.Unmarshal.SymbolMatching BinaryExpression where
    matchedSymbols _ = [174]
    showFailure _ node_54 =
        "expected "
            GHC.Base.<> ( "binary_expression"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_54 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_54) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_55 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_56 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_57 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_58 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_55
            c1_56 = TreeSitter.Node.nodeStartPoint node_54
        TreeSitter.Node.TSPoint
            r2_57
            c2_58 = TreeSitter.Node.nodeEndPoint node_54
deriving instance (GHC.Classes.Eq a_59) => GHC.Classes.Eq (BinaryExpression a_59)
deriving instance (GHC.Classes.Ord a_60) => GHC.Classes.Ord (BinaryExpression a_60)
deriving instance (GHC.Show.Show a_61) => GHC.Show.Show (BinaryExpression a_61)
instance AST.Unmarshal.Unmarshal BinaryExpression
instance Data.Foldable.Foldable BinaryExpression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor BinaryExpression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable BinaryExpression where
    traverse = AST.Traversable1.Class.traverseDefault1
data Block a = Block
    { ann :: a
    , extraChildren :: ([AST.Parse.Err (Statement a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_62.
          AST.Traversable1.Class.Traversable1 a_62
        )
instance AST.Unmarshal.SymbolMatching Block where
    matchedSymbols _ = [125]
    showFailure _ node_63 =
        "expected "
            GHC.Base.<> ( "block"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_63 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_63) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_64 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_65 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_66 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_67 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_64
            c1_65 = TreeSitter.Node.nodeStartPoint node_63
        TreeSitter.Node.TSPoint
            r2_66
            c2_67 = TreeSitter.Node.nodeEndPoint node_63
deriving instance (GHC.Classes.Eq a_68) => GHC.Classes.Eq (Block a_68)
deriving instance (GHC.Classes.Ord a_69) => GHC.Classes.Ord (Block a_69)
deriving instance (GHC.Show.Show a_70) => GHC.Show.Show (Block a_70)
instance AST.Unmarshal.Unmarshal Block
instance Data.Foldable.Foldable Block where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor Block where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable Block where
    traverse = AST.Traversable1.Class.traverseDefault1
data BreakStatement a = BreakStatement
    { ann :: a
    , extraChildren :: (GHC.Maybe.Maybe (AST.Parse.Err (LabelName a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_71.
          AST.Traversable1.Class.Traversable1 a_71
        )
instance AST.Unmarshal.SymbolMatching BreakStatement where
    matchedSymbols _ = [139]
    showFailure _ node_72 =
        "expected "
            GHC.Base.<> ( "break_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_72 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_72) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_73 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_74 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_75 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_76 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_73
            c1_74 = TreeSitter.Node.nodeStartPoint node_72
        TreeSitter.Node.TSPoint
            r2_75
            c2_76 = TreeSitter.Node.nodeEndPoint node_72
deriving instance (GHC.Classes.Eq a_77) => GHC.Classes.Eq (BreakStatement a_77)
deriving instance (GHC.Classes.Ord a_78) => GHC.Classes.Ord (BreakStatement a_78)
deriving instance (GHC.Show.Show a_79) => GHC.Show.Show (BreakStatement a_79)
instance AST.Unmarshal.Unmarshal BreakStatement
instance Data.Foldable.Foldable BreakStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor BreakStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable BreakStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data CallExpression a = CallExpression
    { ann :: a
    , arguments :: (AST.Parse.Err (ArgumentList a))
    , function :: (AST.Parse.Err (Expression a))
    , typeArguments :: (GHC.Maybe.Maybe (AST.Parse.Err (TypeArguments a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_80.
          AST.Traversable1.Class.Traversable1 a_80
        )
instance AST.Unmarshal.SymbolMatching CallExpression where
    matchedSymbols _ = [159]
    showFailure _ node_81 =
        "expected "
            GHC.Base.<> ( "call_expression"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_81 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_81) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_82 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_83 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_84 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_85 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_82
            c1_83 = TreeSitter.Node.nodeStartPoint node_81
        TreeSitter.Node.TSPoint
            r2_84
            c2_85 = TreeSitter.Node.nodeEndPoint node_81
deriving instance (GHC.Classes.Eq a_86) => GHC.Classes.Eq (CallExpression a_86)
deriving instance (GHC.Classes.Ord a_87) => GHC.Classes.Ord (CallExpression a_87)
deriving instance (GHC.Show.Show a_88) => GHC.Show.Show (CallExpression a_88)
instance AST.Unmarshal.Unmarshal CallExpression
instance Data.Foldable.Foldable CallExpression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor CallExpression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable CallExpression where
    traverse = AST.Traversable1.Class.traverseDefault1
data ChannelType a = ChannelType {ann :: a, value :: (AST.Parse.Err (Type a))}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_89.
          AST.Traversable1.Class.Traversable1 a_89
        )
instance AST.Unmarshal.SymbolMatching ChannelType where
    matchedSymbols _ = [123]
    showFailure _ node_90 =
        "expected "
            GHC.Base.<> ( "channel_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_90 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_90) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_91 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_92 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_93 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_94 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_91
            c1_92 = TreeSitter.Node.nodeStartPoint node_90
        TreeSitter.Node.TSPoint
            r2_93
            c2_94 = TreeSitter.Node.nodeEndPoint node_90
deriving instance (GHC.Classes.Eq a_95) => GHC.Classes.Eq (ChannelType a_95)
deriving instance (GHC.Classes.Ord a_96) => GHC.Classes.Ord (ChannelType a_96)
deriving instance (GHC.Show.Show a_97) => GHC.Show.Show (ChannelType a_97)
instance AST.Unmarshal.Unmarshal ChannelType
instance Data.Foldable.Foldable ChannelType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ChannelType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ChannelType where
    traverse = AST.Traversable1.Class.traverseDefault1
data CommunicationCase a = CommunicationCase
    { ann :: a
    , communication :: (AST.Parse.Err ((ReceiveStatement GHC.Generics.:+: SendStatement) a))
    , extraChildren :: ([AST.Parse.Err (Statement a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_98.
          AST.Traversable1.Class.Traversable1 a_98
        )
instance AST.Unmarshal.SymbolMatching CommunicationCase where
    matchedSymbols _ = [156]
    showFailure _ node_99 =
        "expected "
            GHC.Base.<> ( "communication_case"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_99 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_99) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_100 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_101 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_102 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_103 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_100
            c1_101 = TreeSitter.Node.nodeStartPoint node_99
        TreeSitter.Node.TSPoint
            r2_102
            c2_103 = TreeSitter.Node.nodeEndPoint node_99
deriving instance (GHC.Classes.Eq a_104) => GHC.Classes.Eq (CommunicationCase a_104)
deriving instance (GHC.Classes.Ord a_105) => GHC.Classes.Ord (CommunicationCase a_105)
deriving instance (GHC.Show.Show a_106) => GHC.Show.Show (CommunicationCase a_106)
instance AST.Unmarshal.Unmarshal CommunicationCase
instance Data.Foldable.Foldable CommunicationCase where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor CommunicationCase where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable CommunicationCase where
    traverse = AST.Traversable1.Class.traverseDefault1
data CompositeLiteral a = CompositeLiteral
    { ann :: a
    , body :: (AST.Parse.Err (LiteralValue a))
    , type' :: (AST.Parse.Err ((ArrayType GHC.Generics.:+: GenericType GHC.Generics.:+: ImplicitLengthArrayType GHC.Generics.:+: MapType GHC.Generics.:+: QualifiedType GHC.Generics.:+: SliceType GHC.Generics.:+: StructType GHC.Generics.:+: TypeIdentifier) a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_107.
          AST.Traversable1.Class.Traversable1 a_107
        )
instance AST.Unmarshal.SymbolMatching CompositeLiteral where
    matchedSymbols _ = [168]
    showFailure _ node_108 =
        "expected "
            GHC.Base.<> ( "composite_literal"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_108 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_108) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_109 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_110 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_111 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_112 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_109
            c1_110 = TreeSitter.Node.nodeStartPoint node_108
        TreeSitter.Node.TSPoint
            r2_111
            c2_112 = TreeSitter.Node.nodeEndPoint node_108
deriving instance (GHC.Classes.Eq a_113) => GHC.Classes.Eq (CompositeLiteral a_113)
deriving instance (GHC.Classes.Ord a_114) => GHC.Classes.Ord (CompositeLiteral a_114)
deriving instance (GHC.Show.Show a_115) => GHC.Show.Show (CompositeLiteral a_115)
instance AST.Unmarshal.Unmarshal CompositeLiteral
instance Data.Foldable.Foldable CompositeLiteral where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor CompositeLiteral where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable CompositeLiteral where
    traverse = AST.Traversable1.Class.traverseDefault1
data ConstDeclaration a = ConstDeclaration
    { ann :: a
    , extraChildren :: ([AST.Parse.Err (ConstSpec a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_116.
          AST.Traversable1.Class.Traversable1 a_116
        )
instance AST.Unmarshal.SymbolMatching ConstDeclaration where
    matchedSymbols _ = [97]
    showFailure _ node_117 =
        "expected "
            GHC.Base.<> ( "const_declaration"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_117 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_117) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_118 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_119 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_120 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_121 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_118
            c1_119 = TreeSitter.Node.nodeStartPoint node_117
        TreeSitter.Node.TSPoint
            r2_120
            c2_121 = TreeSitter.Node.nodeEndPoint node_117
deriving instance (GHC.Classes.Eq a_122) => GHC.Classes.Eq (ConstDeclaration a_122)
deriving instance (GHC.Classes.Ord a_123) => GHC.Classes.Ord (ConstDeclaration a_123)
deriving instance (GHC.Show.Show a_124) => GHC.Show.Show (ConstDeclaration a_124)
instance AST.Unmarshal.Unmarshal ConstDeclaration
instance Data.Foldable.Foldable ConstDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ConstDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ConstDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
data ConstSpec a = ConstSpec
    { ann :: a
    , value :: (GHC.Maybe.Maybe (AST.Parse.Err (ExpressionList a)))
    , name :: (GHC.Base.NonEmpty (AST.Parse.Err ((AnonymousComma GHC.Generics.:+: Identifier) a)))
    , type' :: (GHC.Maybe.Maybe (AST.Parse.Err (Type a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_125.
          AST.Traversable1.Class.Traversable1 a_125
        )
instance AST.Unmarshal.SymbolMatching ConstSpec where
    matchedSymbols _ = [98]
    showFailure _ node_126 =
        "expected "
            GHC.Base.<> ( "const_spec"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_126 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_126) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_127 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_128 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_129 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_130 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_127
            c1_128 = TreeSitter.Node.nodeStartPoint node_126
        TreeSitter.Node.TSPoint
            r2_129
            c2_130 = TreeSitter.Node.nodeEndPoint node_126
deriving instance (GHC.Classes.Eq a_131) => GHC.Classes.Eq (ConstSpec a_131)
deriving instance (GHC.Classes.Ord a_132) => GHC.Classes.Ord (ConstSpec a_132)
deriving instance (GHC.Show.Show a_133) => GHC.Show.Show (ConstSpec a_133)
instance AST.Unmarshal.Unmarshal ConstSpec
instance Data.Foldable.Foldable ConstSpec where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ConstSpec where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ConstSpec where
    traverse = AST.Traversable1.Class.traverseDefault1
data ContinueStatement a = ContinueStatement
    { ann :: a
    , extraChildren :: (GHC.Maybe.Maybe (AST.Parse.Err (LabelName a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_134.
          AST.Traversable1.Class.Traversable1 a_134
        )
instance AST.Unmarshal.SymbolMatching ContinueStatement where
    matchedSymbols _ = [140]
    showFailure _ node_135 =
        "expected "
            GHC.Base.<> ( "continue_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_135 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_135) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_136 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_137 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_138 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_139 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_136
            c1_137 = TreeSitter.Node.nodeStartPoint node_135
        TreeSitter.Node.TSPoint
            r2_138
            c2_139 = TreeSitter.Node.nodeEndPoint node_135
deriving instance (GHC.Classes.Eq a_140) => GHC.Classes.Eq (ContinueStatement a_140)
deriving instance (GHC.Classes.Ord a_141) => GHC.Classes.Ord (ContinueStatement a_141)
deriving instance (GHC.Show.Show a_142) => GHC.Show.Show (ContinueStatement a_142)
instance AST.Unmarshal.Unmarshal ContinueStatement
instance Data.Foldable.Foldable ContinueStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ContinueStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ContinueStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data DecStatement a = DecStatement
    { ann :: a
    , extraChildren :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_143.
          AST.Traversable1.Class.Traversable1 a_143
        )
instance AST.Unmarshal.SymbolMatching DecStatement where
    matchedSymbols _ = [133]
    showFailure _ node_144 =
        "expected "
            GHC.Base.<> ( "dec_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_144 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_144) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_145 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_146 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_147 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_148 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_145
            c1_146 = TreeSitter.Node.nodeStartPoint node_144
        TreeSitter.Node.TSPoint
            r2_147
            c2_148 = TreeSitter.Node.nodeEndPoint node_144
deriving instance (GHC.Classes.Eq a_149) => GHC.Classes.Eq (DecStatement a_149)
deriving instance (GHC.Classes.Ord a_150) => GHC.Classes.Ord (DecStatement a_150)
deriving instance (GHC.Show.Show a_151) => GHC.Show.Show (DecStatement a_151)
instance AST.Unmarshal.Unmarshal DecStatement
instance Data.Foldable.Foldable DecStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor DecStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable DecStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data DefaultCase a = DefaultCase
    { ann :: a
    , extraChildren :: ([AST.Parse.Err (Statement a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_152.
          AST.Traversable1.Class.Traversable1 a_152
        )
instance AST.Unmarshal.SymbolMatching DefaultCase where
    matchedSymbols _ = [151]
    showFailure _ node_153 =
        "expected "
            GHC.Base.<> ( "default_case"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_153 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_153) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_154 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_155 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_156 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_157 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_154
            c1_155 = TreeSitter.Node.nodeStartPoint node_153
        TreeSitter.Node.TSPoint
            r2_156
            c2_157 = TreeSitter.Node.nodeEndPoint node_153
deriving instance (GHC.Classes.Eq a_158) => GHC.Classes.Eq (DefaultCase a_158)
deriving instance (GHC.Classes.Ord a_159) => GHC.Classes.Ord (DefaultCase a_159)
deriving instance (GHC.Show.Show a_160) => GHC.Show.Show (DefaultCase a_160)
instance AST.Unmarshal.Unmarshal DefaultCase
instance Data.Foldable.Foldable DefaultCase where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor DefaultCase where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable DefaultCase where
    traverse = AST.Traversable1.Class.traverseDefault1
data DeferStatement a = DeferStatement
    { ann :: a
    , extraChildren :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_161.
          AST.Traversable1.Class.Traversable1 a_161
        )
instance AST.Unmarshal.SymbolMatching DeferStatement where
    matchedSymbols _ = [144]
    showFailure _ node_162 =
        "expected "
            GHC.Base.<> ( "defer_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_162 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_162) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_163 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_164 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_165 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_166 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_163
            c1_164 = TreeSitter.Node.nodeStartPoint node_162
        TreeSitter.Node.TSPoint
            r2_165
            c2_166 = TreeSitter.Node.nodeEndPoint node_162
deriving instance (GHC.Classes.Eq a_167) => GHC.Classes.Eq (DeferStatement a_167)
deriving instance (GHC.Classes.Ord a_168) => GHC.Classes.Ord (DeferStatement a_168)
deriving instance (GHC.Show.Show a_169) => GHC.Show.Show (DeferStatement a_169)
instance AST.Unmarshal.Unmarshal DeferStatement
instance Data.Foldable.Foldable DeferStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor DeferStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable DeferStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data Dot a = Dot {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_170.
          AST.Traversable1.Class.Traversable1 a_170
        )
instance AST.Unmarshal.SymbolMatching Dot where
    matchedSymbols _ = [94]
    showFailure _ node_171 =
        "expected "
            GHC.Base.<> ( "dot"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_171 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_171) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_172 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_173 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_174 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_175 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_172
            c1_173 = TreeSitter.Node.nodeStartPoint node_171
        TreeSitter.Node.TSPoint
            r2_174
            c2_175 = TreeSitter.Node.nodeEndPoint node_171
deriving instance (GHC.Classes.Eq a_176) => GHC.Classes.Eq (Dot a_176)
deriving instance (GHC.Classes.Ord a_177) => GHC.Classes.Ord (Dot a_177)
deriving instance (GHC.Show.Show a_178) => GHC.Show.Show (Dot a_178)
instance AST.Unmarshal.Unmarshal Dot
instance Data.Foldable.Foldable Dot where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor Dot where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable Dot where
    traverse = AST.Traversable1.Class.traverseDefault1
data EmptyStatement a = EmptyStatement {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_179.
          AST.Traversable1.Class.Traversable1 a_179
        )
instance AST.Unmarshal.SymbolMatching EmptyStatement where
    matchedSymbols _ = [128]
    showFailure _ node_180 =
        "expected "
            GHC.Base.<> ( "empty_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_180 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_180) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_181 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_182 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_183 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_184 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_181
            c1_182 = TreeSitter.Node.nodeStartPoint node_180
        TreeSitter.Node.TSPoint
            r2_183
            c2_184 = TreeSitter.Node.nodeEndPoint node_180
deriving instance (GHC.Classes.Eq a_185) => GHC.Classes.Eq (EmptyStatement a_185)
deriving instance (GHC.Classes.Ord a_186) => GHC.Classes.Ord (EmptyStatement a_186)
deriving instance (GHC.Show.Show a_187) => GHC.Show.Show (EmptyStatement a_187)
instance AST.Unmarshal.Unmarshal EmptyStatement
instance Data.Foldable.Foldable EmptyStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor EmptyStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable EmptyStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data ExpressionCase a = ExpressionCase
    { ann :: a
    , value :: (AST.Parse.Err (ExpressionList a))
    , extraChildren :: ([AST.Parse.Err (Statement a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_188.
          AST.Traversable1.Class.Traversable1 a_188
        )
instance AST.Unmarshal.SymbolMatching ExpressionCase where
    matchedSymbols _ = [150]
    showFailure _ node_189 =
        "expected "
            GHC.Base.<> ( "expression_case"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_189 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_189) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_190 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_191 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_192 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_193 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_190
            c1_191 = TreeSitter.Node.nodeStartPoint node_189
        TreeSitter.Node.TSPoint
            r2_192
            c2_193 = TreeSitter.Node.nodeEndPoint node_189
deriving instance (GHC.Classes.Eq a_194) => GHC.Classes.Eq (ExpressionCase a_194)
deriving instance (GHC.Classes.Ord a_195) => GHC.Classes.Ord (ExpressionCase a_195)
deriving instance (GHC.Show.Show a_196) => GHC.Show.Show (ExpressionCase a_196)
instance AST.Unmarshal.Unmarshal ExpressionCase
instance Data.Foldable.Foldable ExpressionCase where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ExpressionCase where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ExpressionCase where
    traverse = AST.Traversable1.Class.traverseDefault1
data ExpressionList a = ExpressionList
    { ann :: a
    , extraChildren :: (GHC.Base.NonEmpty (AST.Parse.Err (Expression a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_197.
          AST.Traversable1.Class.Traversable1 a_197
        )
instance AST.Unmarshal.SymbolMatching ExpressionList where
    matchedSymbols _ = [109]
    showFailure _ node_198 =
        "expected "
            GHC.Base.<> ( "expression_list"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_198 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_198) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_199 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_200 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_201 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_202 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_199
            c1_200 = TreeSitter.Node.nodeStartPoint node_198
        TreeSitter.Node.TSPoint
            r2_201
            c2_202 = TreeSitter.Node.nodeEndPoint node_198
deriving instance (GHC.Classes.Eq a_203) => GHC.Classes.Eq (ExpressionList a_203)
deriving instance (GHC.Classes.Ord a_204) => GHC.Classes.Ord (ExpressionList a_204)
deriving instance (GHC.Show.Show a_205) => GHC.Show.Show (ExpressionList a_205)
instance AST.Unmarshal.Unmarshal ExpressionList
instance Data.Foldable.Foldable ExpressionList where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ExpressionList where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ExpressionList where
    traverse = AST.Traversable1.Class.traverseDefault1
data ExpressionStatement a = ExpressionStatement
    { ann :: a
    , extraChildren :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_206.
          AST.Traversable1.Class.Traversable1 a_206
        )
instance AST.Unmarshal.SymbolMatching ExpressionStatement where
    matchedSymbols _ = []
    showFailure _ node_207 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_207 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_207) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_208 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_209 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_210 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_211 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_208
            c1_209 = TreeSitter.Node.nodeStartPoint node_207
        TreeSitter.Node.TSPoint
            r2_210
            c2_211 = TreeSitter.Node.nodeEndPoint node_207
deriving instance (GHC.Classes.Eq a_212) => GHC.Classes.Eq (ExpressionStatement a_212)
deriving instance (GHC.Classes.Ord a_213) => GHC.Classes.Ord (ExpressionStatement a_213)
deriving instance (GHC.Show.Show a_214) => GHC.Show.Show (ExpressionStatement a_214)
instance AST.Unmarshal.Unmarshal ExpressionStatement
instance Data.Foldable.Foldable ExpressionStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ExpressionStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ExpressionStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data ExpressionSwitchStatement a = ExpressionSwitchStatement
    { ann :: a
    , value :: (GHC.Maybe.Maybe (AST.Parse.Err (Expression a)))
    , initializer :: (GHC.Maybe.Maybe (AST.Parse.Err (SimpleStatement a)))
    , extraChildren :: ([AST.Parse.Err ((DefaultCase GHC.Generics.:+: ExpressionCase) a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_215.
          AST.Traversable1.Class.Traversable1 a_215
        )
instance AST.Unmarshal.SymbolMatching ExpressionSwitchStatement where
    matchedSymbols _ = [149]
    showFailure _ node_216 =
        "expected "
            GHC.Base.<> ( "expression_switch_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_216 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_216) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_217 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_218 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_219 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_220 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_217
            c1_218 = TreeSitter.Node.nodeStartPoint node_216
        TreeSitter.Node.TSPoint
            r2_219
            c2_220 = TreeSitter.Node.nodeEndPoint node_216
deriving instance (GHC.Classes.Eq a_221) => GHC.Classes.Eq (ExpressionSwitchStatement a_221)
deriving instance (GHC.Classes.Ord a_222) => GHC.Classes.Ord (ExpressionSwitchStatement a_222)
deriving instance (GHC.Show.Show a_223) => GHC.Show.Show (ExpressionSwitchStatement a_223)
instance AST.Unmarshal.Unmarshal ExpressionSwitchStatement
instance Data.Foldable.Foldable ExpressionSwitchStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ExpressionSwitchStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ExpressionSwitchStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data FallthroughStatement a = FallthroughStatement {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_224.
          AST.Traversable1.Class.Traversable1 a_224
        )
instance AST.Unmarshal.SymbolMatching FallthroughStatement where
    matchedSymbols _ = [138]
    showFailure _ node_225 =
        "expected "
            GHC.Base.<> ( "fallthrough_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_225 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_225) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_226 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_227 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_228 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_229 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_226
            c1_227 = TreeSitter.Node.nodeStartPoint node_225
        TreeSitter.Node.TSPoint
            r2_228
            c2_229 = TreeSitter.Node.nodeEndPoint node_225
deriving instance (GHC.Classes.Eq a_230) => GHC.Classes.Eq (FallthroughStatement a_230)
deriving instance (GHC.Classes.Ord a_231) => GHC.Classes.Ord (FallthroughStatement a_231)
deriving instance (GHC.Show.Show a_232) => GHC.Show.Show (FallthroughStatement a_232)
instance AST.Unmarshal.Unmarshal FallthroughStatement
instance Data.Foldable.Foldable FallthroughStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor FallthroughStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable FallthroughStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data FieldDeclaration a = FieldDeclaration
    { ann :: a
    , tag :: (GHC.Maybe.Maybe (AST.Parse.Err ((InterpretedStringLiteral GHC.Generics.:+: RawStringLiteral) a)))
    , name :: ([AST.Parse.Err (FieldIdentifier a)])
    , type' :: (AST.Parse.Err ((Type GHC.Generics.:+: GenericType GHC.Generics.:+: QualifiedType GHC.Generics.:+: TypeIdentifier) a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_233.
          AST.Traversable1.Class.Traversable1 a_233
        )
instance AST.Unmarshal.SymbolMatching FieldDeclaration where
    matchedSymbols _ = [118]
    showFailure _ node_234 =
        "expected "
            GHC.Base.<> ( "field_declaration"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_234 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_234) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_235 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_236 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_237 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_238 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_235
            c1_236 = TreeSitter.Node.nodeStartPoint node_234
        TreeSitter.Node.TSPoint
            r2_237
            c2_238 = TreeSitter.Node.nodeEndPoint node_234
deriving instance (GHC.Classes.Eq a_239) => GHC.Classes.Eq (FieldDeclaration a_239)
deriving instance (GHC.Classes.Ord a_240) => GHC.Classes.Ord (FieldDeclaration a_240)
deriving instance (GHC.Show.Show a_241) => GHC.Show.Show (FieldDeclaration a_241)
instance AST.Unmarshal.Unmarshal FieldDeclaration
instance Data.Foldable.Foldable FieldDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor FieldDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable FieldDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
data FieldDeclarationList a = FieldDeclarationList
    { ann :: a
    , extraChildren :: ([AST.Parse.Err (FieldDeclaration a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_242.
          AST.Traversable1.Class.Traversable1 a_242
        )
instance AST.Unmarshal.SymbolMatching FieldDeclarationList where
    matchedSymbols _ = [117]
    showFailure _ node_243 =
        "expected "
            GHC.Base.<> ( "field_declaration_list"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_243 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_243) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_244 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_245 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_246 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_247 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_244
            c1_245 = TreeSitter.Node.nodeStartPoint node_243
        TreeSitter.Node.TSPoint
            r2_246
            c2_247 = TreeSitter.Node.nodeEndPoint node_243
deriving instance (GHC.Classes.Eq a_248) => GHC.Classes.Eq (FieldDeclarationList a_248)
deriving instance (GHC.Classes.Ord a_249) => GHC.Classes.Ord (FieldDeclarationList a_249)
deriving instance (GHC.Show.Show a_250) => GHC.Show.Show (FieldDeclarationList a_250)
instance AST.Unmarshal.Unmarshal FieldDeclarationList
instance Data.Foldable.Foldable FieldDeclarationList where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor FieldDeclarationList where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable FieldDeclarationList where
    traverse = AST.Traversable1.Class.traverseDefault1
data ForClause a = ForClause
    { ann :: a
    , condition :: (GHC.Maybe.Maybe (AST.Parse.Err (Expression a)))
    , initializer :: (GHC.Maybe.Maybe (AST.Parse.Err (SimpleStatement a)))
    , update :: (GHC.Maybe.Maybe (AST.Parse.Err (SimpleStatement a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_251.
          AST.Traversable1.Class.Traversable1 a_251
        )
instance AST.Unmarshal.SymbolMatching ForClause where
    matchedSymbols _ = [147]
    showFailure _ node_252 =
        "expected "
            GHC.Base.<> ( "for_clause"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_252 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_252) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_253 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_254 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_255 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_256 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_253
            c1_254 = TreeSitter.Node.nodeStartPoint node_252
        TreeSitter.Node.TSPoint
            r2_255
            c2_256 = TreeSitter.Node.nodeEndPoint node_252
deriving instance (GHC.Classes.Eq a_257) => GHC.Classes.Eq (ForClause a_257)
deriving instance (GHC.Classes.Ord a_258) => GHC.Classes.Ord (ForClause a_258)
deriving instance (GHC.Show.Show a_259) => GHC.Show.Show (ForClause a_259)
instance AST.Unmarshal.Unmarshal ForClause
instance Data.Foldable.Foldable ForClause where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ForClause where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ForClause where
    traverse = AST.Traversable1.Class.traverseDefault1
data ForStatement a = ForStatement
    { ann :: a
    , body :: (AST.Parse.Err (Block a))
    , extraChildren :: (GHC.Maybe.Maybe (AST.Parse.Err ((Expression GHC.Generics.:+: ForClause GHC.Generics.:+: RangeClause) a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_260.
          AST.Traversable1.Class.Traversable1 a_260
        )
instance AST.Unmarshal.SymbolMatching ForStatement where
    matchedSymbols _ = [146]
    showFailure _ node_261 =
        "expected "
            GHC.Base.<> ( "for_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_261 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_261) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_262 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_263 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_264 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_265 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_262
            c1_263 = TreeSitter.Node.nodeStartPoint node_261
        TreeSitter.Node.TSPoint
            r2_264
            c2_265 = TreeSitter.Node.nodeEndPoint node_261
deriving instance (GHC.Classes.Eq a_266) => GHC.Classes.Eq (ForStatement a_266)
deriving instance (GHC.Classes.Ord a_267) => GHC.Classes.Ord (ForStatement a_267)
deriving instance (GHC.Show.Show a_268) => GHC.Show.Show (ForStatement a_268)
instance AST.Unmarshal.Unmarshal ForStatement
instance Data.Foldable.Foldable ForStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ForStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ForStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data FuncLiteral a = FuncLiteral
    { ann :: a
    , body :: (AST.Parse.Err (Block a))
    , result :: (GHC.Maybe.Maybe (AST.Parse.Err ((SimpleType GHC.Generics.:+: ParameterList) a)))
    , parameters :: (AST.Parse.Err (ParameterList a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_269.
          AST.Traversable1.Class.Traversable1 a_269
        )
instance AST.Unmarshal.SymbolMatching FuncLiteral where
    matchedSymbols _ = [172]
    showFailure _ node_270 =
        "expected "
            GHC.Base.<> ( "func_literal"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_270 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_270) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_271 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_272 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_273 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_274 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_271
            c1_272 = TreeSitter.Node.nodeStartPoint node_270
        TreeSitter.Node.TSPoint
            r2_273
            c2_274 = TreeSitter.Node.nodeEndPoint node_270
deriving instance (GHC.Classes.Eq a_275) => GHC.Classes.Eq (FuncLiteral a_275)
deriving instance (GHC.Classes.Ord a_276) => GHC.Classes.Ord (FuncLiteral a_276)
deriving instance (GHC.Show.Show a_277) => GHC.Show.Show (FuncLiteral a_277)
instance AST.Unmarshal.Unmarshal FuncLiteral
instance Data.Foldable.Foldable FuncLiteral where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor FuncLiteral where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable FuncLiteral where
    traverse = AST.Traversable1.Class.traverseDefault1
data FunctionDeclaration a = FunctionDeclaration
    { ann :: a
    , body :: (GHC.Maybe.Maybe (AST.Parse.Err (Block a)))
    , typeParameters :: (GHC.Maybe.Maybe (AST.Parse.Err (TypeParameterList a)))
    , name :: (AST.Parse.Err (Identifier a))
    , result :: (GHC.Maybe.Maybe (AST.Parse.Err ((SimpleType GHC.Generics.:+: ParameterList) a)))
    , parameters :: (AST.Parse.Err (ParameterList a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_278.
          AST.Traversable1.Class.Traversable1 a_278
        )
instance AST.Unmarshal.SymbolMatching FunctionDeclaration where
    matchedSymbols _ = [101]
    showFailure _ node_279 =
        "expected "
            GHC.Base.<> ( "function_declaration"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_279 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_279) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_280 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_281 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_282 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_283 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_280
            c1_281 = TreeSitter.Node.nodeStartPoint node_279
        TreeSitter.Node.TSPoint
            r2_282
            c2_283 = TreeSitter.Node.nodeEndPoint node_279
deriving instance (GHC.Classes.Eq a_284) => GHC.Classes.Eq (FunctionDeclaration a_284)
deriving instance (GHC.Classes.Ord a_285) => GHC.Classes.Ord (FunctionDeclaration a_285)
deriving instance (GHC.Show.Show a_286) => GHC.Show.Show (FunctionDeclaration a_286)
instance AST.Unmarshal.Unmarshal FunctionDeclaration
instance Data.Foldable.Foldable FunctionDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor FunctionDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable FunctionDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
data FunctionType a = FunctionType
    { ann :: a
    , result :: (GHC.Maybe.Maybe (AST.Parse.Err ((SimpleType GHC.Generics.:+: ParameterList) a)))
    , parameters :: (AST.Parse.Err (ParameterList a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_287.
          AST.Traversable1.Class.Traversable1 a_287
        )
instance AST.Unmarshal.SymbolMatching FunctionType where
    matchedSymbols _ = [124]
    showFailure _ node_288 =
        "expected "
            GHC.Base.<> ( "function_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_288 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_288) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_289 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_290 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_291 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_292 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_289
            c1_290 = TreeSitter.Node.nodeStartPoint node_288
        TreeSitter.Node.TSPoint
            r2_291
            c2_292 = TreeSitter.Node.nodeEndPoint node_288
deriving instance (GHC.Classes.Eq a_293) => GHC.Classes.Eq (FunctionType a_293)
deriving instance (GHC.Classes.Ord a_294) => GHC.Classes.Ord (FunctionType a_294)
deriving instance (GHC.Show.Show a_295) => GHC.Show.Show (FunctionType a_295)
instance AST.Unmarshal.Unmarshal FunctionType
instance Data.Foldable.Foldable FunctionType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor FunctionType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable FunctionType where
    traverse = AST.Traversable1.Class.traverseDefault1
data GenericType a = GenericType
    { ann :: a
    , typeArguments :: (AST.Parse.Err (TypeArguments a))
    , type' :: (AST.Parse.Err ((NegatedType GHC.Generics.:+: QualifiedType GHC.Generics.:+: TypeIdentifier) a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_296.
          AST.Traversable1.Class.Traversable1 a_296
        )
instance AST.Unmarshal.SymbolMatching GenericType where
    matchedSymbols _ = []
    showFailure _ node_297 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_297 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_297) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_298 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_299 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_300 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_301 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_298
            c1_299 = TreeSitter.Node.nodeStartPoint node_297
        TreeSitter.Node.TSPoint
            r2_300
            c2_301 = TreeSitter.Node.nodeEndPoint node_297
deriving instance (GHC.Classes.Eq a_302) => GHC.Classes.Eq (GenericType a_302)
deriving instance (GHC.Classes.Ord a_303) => GHC.Classes.Ord (GenericType a_303)
deriving instance (GHC.Show.Show a_304) => GHC.Show.Show (GenericType a_304)
instance AST.Unmarshal.Unmarshal GenericType
instance Data.Foldable.Foldable GenericType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor GenericType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable GenericType where
    traverse = AST.Traversable1.Class.traverseDefault1
data GoStatement a = GoStatement
    { ann :: a
    , extraChildren :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_305.
          AST.Traversable1.Class.Traversable1 a_305
        )
instance AST.Unmarshal.SymbolMatching GoStatement where
    matchedSymbols _ = [143]
    showFailure _ node_306 =
        "expected "
            GHC.Base.<> ( "go_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_306 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_306) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_307 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_308 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_309 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_310 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_307
            c1_308 = TreeSitter.Node.nodeStartPoint node_306
        TreeSitter.Node.TSPoint
            r2_309
            c2_310 = TreeSitter.Node.nodeEndPoint node_306
deriving instance (GHC.Classes.Eq a_311) => GHC.Classes.Eq (GoStatement a_311)
deriving instance (GHC.Classes.Ord a_312) => GHC.Classes.Ord (GoStatement a_312)
deriving instance (GHC.Show.Show a_313) => GHC.Show.Show (GoStatement a_313)
instance AST.Unmarshal.Unmarshal GoStatement
instance Data.Foldable.Foldable GoStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor GoStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable GoStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data GotoStatement a = GotoStatement
    { ann :: a
    , extraChildren :: (AST.Parse.Err (LabelName a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_314.
          AST.Traversable1.Class.Traversable1 a_314
        )
instance AST.Unmarshal.SymbolMatching GotoStatement where
    matchedSymbols _ = [141]
    showFailure _ node_315 =
        "expected "
            GHC.Base.<> ( "goto_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_315 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_315) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_316 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_317 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_318 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_319 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_316
            c1_317 = TreeSitter.Node.nodeStartPoint node_315
        TreeSitter.Node.TSPoint
            r2_318
            c2_319 = TreeSitter.Node.nodeEndPoint node_315
deriving instance (GHC.Classes.Eq a_320) => GHC.Classes.Eq (GotoStatement a_320)
deriving instance (GHC.Classes.Ord a_321) => GHC.Classes.Ord (GotoStatement a_321)
deriving instance (GHC.Show.Show a_322) => GHC.Show.Show (GotoStatement a_322)
instance AST.Unmarshal.Unmarshal GotoStatement
instance Data.Foldable.Foldable GotoStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor GotoStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable GotoStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data IfStatement a = IfStatement
    { ann :: a
    , consequence :: (AST.Parse.Err (Block a))
    , condition :: (AST.Parse.Err (Expression a))
    , alternative :: (GHC.Maybe.Maybe (AST.Parse.Err ((Block GHC.Generics.:+: IfStatement) a)))
    , initializer :: (GHC.Maybe.Maybe (AST.Parse.Err (SimpleStatement a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_323.
          AST.Traversable1.Class.Traversable1 a_323
        )
instance AST.Unmarshal.SymbolMatching IfStatement where
    matchedSymbols _ = [145]
    showFailure _ node_324 =
        "expected "
            GHC.Base.<> ( "if_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_324 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_324) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_325 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_326 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_327 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_328 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_325
            c1_326 = TreeSitter.Node.nodeStartPoint node_324
        TreeSitter.Node.TSPoint
            r2_327
            c2_328 = TreeSitter.Node.nodeEndPoint node_324
deriving instance (GHC.Classes.Eq a_329) => GHC.Classes.Eq (IfStatement a_329)
deriving instance (GHC.Classes.Ord a_330) => GHC.Classes.Ord (IfStatement a_330)
deriving instance (GHC.Show.Show a_331) => GHC.Show.Show (IfStatement a_331)
instance AST.Unmarshal.Unmarshal IfStatement
instance Data.Foldable.Foldable IfStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor IfStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable IfStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data ImplicitLengthArrayType a = ImplicitLengthArrayType
    { ann :: a
    , element :: (AST.Parse.Err (Type a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_332.
          AST.Traversable1.Class.Traversable1 a_332
        )
instance AST.Unmarshal.SymbolMatching ImplicitLengthArrayType where
    matchedSymbols _ = [114]
    showFailure _ node_333 =
        "expected "
            GHC.Base.<> ( "implicit_length_array_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_333 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_333) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_334 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_335 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_336 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_337 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_334
            c1_335 = TreeSitter.Node.nodeStartPoint node_333
        TreeSitter.Node.TSPoint
            r2_336
            c2_337 = TreeSitter.Node.nodeEndPoint node_333
deriving instance (GHC.Classes.Eq a_338) => GHC.Classes.Eq (ImplicitLengthArrayType a_338)
deriving instance (GHC.Classes.Ord a_339) => GHC.Classes.Ord (ImplicitLengthArrayType a_339)
deriving instance (GHC.Show.Show a_340) => GHC.Show.Show (ImplicitLengthArrayType a_340)
instance AST.Unmarshal.Unmarshal ImplicitLengthArrayType
instance Data.Foldable.Foldable ImplicitLengthArrayType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ImplicitLengthArrayType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ImplicitLengthArrayType where
    traverse = AST.Traversable1.Class.traverseDefault1
data ImportDeclaration a = ImportDeclaration
    { ann :: a
    , extraChildren :: (AST.Parse.Err ((ImportSpec GHC.Generics.:+: ImportSpecList) a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_341.
          AST.Traversable1.Class.Traversable1 a_341
        )
instance AST.Unmarshal.SymbolMatching ImportDeclaration where
    matchedSymbols _ = [92]
    showFailure _ node_342 =
        "expected "
            GHC.Base.<> ( "import_declaration"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_342 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_342) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_343 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_344 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_345 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_346 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_343
            c1_344 = TreeSitter.Node.nodeStartPoint node_342
        TreeSitter.Node.TSPoint
            r2_345
            c2_346 = TreeSitter.Node.nodeEndPoint node_342
deriving instance (GHC.Classes.Eq a_347) => GHC.Classes.Eq (ImportDeclaration a_347)
deriving instance (GHC.Classes.Ord a_348) => GHC.Classes.Ord (ImportDeclaration a_348)
deriving instance (GHC.Show.Show a_349) => GHC.Show.Show (ImportDeclaration a_349)
instance AST.Unmarshal.Unmarshal ImportDeclaration
instance Data.Foldable.Foldable ImportDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ImportDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ImportDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
data ImportSpec a = ImportSpec
    { ann :: a
    , path :: (AST.Parse.Err ((InterpretedStringLiteral GHC.Generics.:+: RawStringLiteral) a))
    , name :: (GHC.Maybe.Maybe (AST.Parse.Err ((BlankIdentifier GHC.Generics.:+: Dot GHC.Generics.:+: PackageIdentifier) a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_350.
          AST.Traversable1.Class.Traversable1 a_350
        )
instance AST.Unmarshal.SymbolMatching ImportSpec where
    matchedSymbols _ = [93]
    showFailure _ node_351 =
        "expected "
            GHC.Base.<> ( "import_spec"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_351 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_351) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_352 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_353 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_354 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_355 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_352
            c1_353 = TreeSitter.Node.nodeStartPoint node_351
        TreeSitter.Node.TSPoint
            r2_354
            c2_355 = TreeSitter.Node.nodeEndPoint node_351
deriving instance (GHC.Classes.Eq a_356) => GHC.Classes.Eq (ImportSpec a_356)
deriving instance (GHC.Classes.Ord a_357) => GHC.Classes.Ord (ImportSpec a_357)
deriving instance (GHC.Show.Show a_358) => GHC.Show.Show (ImportSpec a_358)
instance AST.Unmarshal.Unmarshal ImportSpec
instance Data.Foldable.Foldable ImportSpec where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ImportSpec where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ImportSpec where
    traverse = AST.Traversable1.Class.traverseDefault1
data ImportSpecList a = ImportSpecList
    { ann :: a
    , extraChildren :: ([AST.Parse.Err (ImportSpec a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_359.
          AST.Traversable1.Class.Traversable1 a_359
        )
instance AST.Unmarshal.SymbolMatching ImportSpecList where
    matchedSymbols _ = [95]
    showFailure _ node_360 =
        "expected "
            GHC.Base.<> ( "import_spec_list"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_360 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_360) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_361 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_362 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_363 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_364 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_361
            c1_362 = TreeSitter.Node.nodeStartPoint node_360
        TreeSitter.Node.TSPoint
            r2_363
            c2_364 = TreeSitter.Node.nodeEndPoint node_360
deriving instance (GHC.Classes.Eq a_365) => GHC.Classes.Eq (ImportSpecList a_365)
deriving instance (GHC.Classes.Ord a_366) => GHC.Classes.Ord (ImportSpecList a_366)
deriving instance (GHC.Show.Show a_367) => GHC.Show.Show (ImportSpecList a_367)
instance AST.Unmarshal.Unmarshal ImportSpecList
instance Data.Foldable.Foldable ImportSpecList where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ImportSpecList where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ImportSpecList where
    traverse = AST.Traversable1.Class.traverseDefault1
data IncStatement a = IncStatement
    { ann :: a
    , extraChildren :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_368.
          AST.Traversable1.Class.Traversable1 a_368
        )
instance AST.Unmarshal.SymbolMatching IncStatement where
    matchedSymbols _ = [132]
    showFailure _ node_369 =
        "expected "
            GHC.Base.<> ( "inc_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_369 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_369) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_370 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_371 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_372 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_373 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_370
            c1_371 = TreeSitter.Node.nodeStartPoint node_369
        TreeSitter.Node.TSPoint
            r2_372
            c2_373 = TreeSitter.Node.nodeEndPoint node_369
deriving instance (GHC.Classes.Eq a_374) => GHC.Classes.Eq (IncStatement a_374)
deriving instance (GHC.Classes.Ord a_375) => GHC.Classes.Ord (IncStatement a_375)
deriving instance (GHC.Show.Show a_376) => GHC.Show.Show (IncStatement a_376)
instance AST.Unmarshal.Unmarshal IncStatement
instance Data.Foldable.Foldable IncStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor IncStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable IncStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data IndexExpression a = IndexExpression
    { ann :: a
    , index :: (AST.Parse.Err (Expression a))
    , operand :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_377.
          AST.Traversable1.Class.Traversable1 a_377
        )
instance AST.Unmarshal.SymbolMatching IndexExpression where
    matchedSymbols _ = [164]
    showFailure _ node_378 =
        "expected "
            GHC.Base.<> ( "index_expression"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_378 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_378) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_379 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_380 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_381 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_382 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_379
            c1_380 = TreeSitter.Node.nodeStartPoint node_378
        TreeSitter.Node.TSPoint
            r2_381
            c2_382 = TreeSitter.Node.nodeEndPoint node_378
deriving instance (GHC.Classes.Eq a_383) => GHC.Classes.Eq (IndexExpression a_383)
deriving instance (GHC.Classes.Ord a_384) => GHC.Classes.Ord (IndexExpression a_384)
deriving instance (GHC.Show.Show a_385) => GHC.Show.Show (IndexExpression a_385)
instance AST.Unmarshal.Unmarshal IndexExpression
instance Data.Foldable.Foldable IndexExpression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor IndexExpression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable IndexExpression where
    traverse = AST.Traversable1.Class.traverseDefault1
data InterfaceType a = InterfaceType
    { ann :: a
    , extraChildren :: ([AST.Parse.Err ((MethodElem GHC.Generics.:+: TypeElem) a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_386.
          AST.Traversable1.Class.Traversable1 a_386
        )
instance AST.Unmarshal.SymbolMatching InterfaceType where
    matchedSymbols _ = [119]
    showFailure _ node_387 =
        "expected "
            GHC.Base.<> ( "interface_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_387 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_387) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_388 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_389 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_390 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_391 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_388
            c1_389 = TreeSitter.Node.nodeStartPoint node_387
        TreeSitter.Node.TSPoint
            r2_390
            c2_391 = TreeSitter.Node.nodeEndPoint node_387
deriving instance (GHC.Classes.Eq a_392) => GHC.Classes.Eq (InterfaceType a_392)
deriving instance (GHC.Classes.Ord a_393) => GHC.Classes.Ord (InterfaceType a_393)
deriving instance (GHC.Show.Show a_394) => GHC.Show.Show (InterfaceType a_394)
instance AST.Unmarshal.Unmarshal InterfaceType
instance Data.Foldable.Foldable InterfaceType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor InterfaceType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable InterfaceType where
    traverse = AST.Traversable1.Class.traverseDefault1
data InterpretedStringLiteral a = InterpretedStringLiteral
    { ann :: a
    , extraChildren :: ([AST.Parse.Err ((EscapeSequence GHC.Generics.:+: InterpretedStringLiteralContent) a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_395.
          AST.Traversable1.Class.Traversable1 a_395
        )
instance AST.Unmarshal.SymbolMatching InterpretedStringLiteral where
    matchedSymbols _ = [176]
    showFailure _ node_396 =
        "expected "
            GHC.Base.<> ( "interpreted_string_literal"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_396 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_396) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_397 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_398 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_399 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_400 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_397
            c1_398 = TreeSitter.Node.nodeStartPoint node_396
        TreeSitter.Node.TSPoint
            r2_399
            c2_400 = TreeSitter.Node.nodeEndPoint node_396
deriving instance (GHC.Classes.Eq a_401) => GHC.Classes.Eq (InterpretedStringLiteral a_401)
deriving instance (GHC.Classes.Ord a_402) => GHC.Classes.Ord (InterpretedStringLiteral a_402)
deriving instance (GHC.Show.Show a_403) => GHC.Show.Show (InterpretedStringLiteral a_403)
instance AST.Unmarshal.Unmarshal InterpretedStringLiteral
instance Data.Foldable.Foldable InterpretedStringLiteral where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor InterpretedStringLiteral where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable InterpretedStringLiteral where
    traverse = AST.Traversable1.Class.traverseDefault1
data KeyedElement a = KeyedElement
    { ann :: a
    , value :: (AST.Parse.Err (LiteralElement a))
    , key :: (AST.Parse.Err (LiteralElement a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_404.
          AST.Traversable1.Class.Traversable1 a_404
        )
instance AST.Unmarshal.SymbolMatching KeyedElement where
    matchedSymbols _ = [170]
    showFailure _ node_405 =
        "expected "
            GHC.Base.<> ( "keyed_element"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_405 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_405) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_406 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_407 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_408 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_409 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_406
            c1_407 = TreeSitter.Node.nodeStartPoint node_405
        TreeSitter.Node.TSPoint
            r2_408
            c2_409 = TreeSitter.Node.nodeEndPoint node_405
deriving instance (GHC.Classes.Eq a_410) => GHC.Classes.Eq (KeyedElement a_410)
deriving instance (GHC.Classes.Ord a_411) => GHC.Classes.Ord (KeyedElement a_411)
deriving instance (GHC.Show.Show a_412) => GHC.Show.Show (KeyedElement a_412)
instance AST.Unmarshal.Unmarshal KeyedElement
instance Data.Foldable.Foldable KeyedElement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor KeyedElement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable KeyedElement where
    traverse = AST.Traversable1.Class.traverseDefault1
data LabeledStatement a = LabeledStatement
    { ann :: a
    , label :: (AST.Parse.Err (LabelName a))
    , extraChildren :: (GHC.Maybe.Maybe (AST.Parse.Err (Statement a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_413.
          AST.Traversable1.Class.Traversable1 a_413
        )
instance AST.Unmarshal.SymbolMatching LabeledStatement where
    matchedSymbols _ = [136, 137]
    showFailure _ node_414 =
        "expected "
            GHC.Base.<> ( "labeled_statement, labeled_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_414 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_414) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_415 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_416 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_417 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_418 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_415
            c1_416 = TreeSitter.Node.nodeStartPoint node_414
        TreeSitter.Node.TSPoint
            r2_417
            c2_418 = TreeSitter.Node.nodeEndPoint node_414
deriving instance (GHC.Classes.Eq a_419) => GHC.Classes.Eq (LabeledStatement a_419)
deriving instance (GHC.Classes.Ord a_420) => GHC.Classes.Ord (LabeledStatement a_420)
deriving instance (GHC.Show.Show a_421) => GHC.Show.Show (LabeledStatement a_421)
instance AST.Unmarshal.Unmarshal LabeledStatement
instance Data.Foldable.Foldable LabeledStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor LabeledStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable LabeledStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data LiteralElement a = LiteralElement
    { ann :: a
    , extraChildren :: (AST.Parse.Err ((Expression GHC.Generics.:+: LiteralValue) a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_422.
          AST.Traversable1.Class.Traversable1 a_422
        )
instance AST.Unmarshal.SymbolMatching LiteralElement where
    matchedSymbols _ = []
    showFailure _ node_423 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_423 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_423) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_424 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_425 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_426 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_427 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_424
            c1_425 = TreeSitter.Node.nodeStartPoint node_423
        TreeSitter.Node.TSPoint
            r2_426
            c2_427 = TreeSitter.Node.nodeEndPoint node_423
deriving instance (GHC.Classes.Eq a_428) => GHC.Classes.Eq (LiteralElement a_428)
deriving instance (GHC.Classes.Ord a_429) => GHC.Classes.Ord (LiteralElement a_429)
deriving instance (GHC.Show.Show a_430) => GHC.Show.Show (LiteralElement a_430)
instance AST.Unmarshal.Unmarshal LiteralElement
instance Data.Foldable.Foldable LiteralElement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor LiteralElement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable LiteralElement where
    traverse = AST.Traversable1.Class.traverseDefault1
data LiteralValue a = LiteralValue
    { ann :: a
    , extraChildren :: ([AST.Parse.Err ((KeyedElement GHC.Generics.:+: LiteralElement) a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_431.
          AST.Traversable1.Class.Traversable1 a_431
        )
instance AST.Unmarshal.SymbolMatching LiteralValue where
    matchedSymbols _ = [169]
    showFailure _ node_432 =
        "expected "
            GHC.Base.<> ( "literal_value"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_432 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_432) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_433 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_434 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_435 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_436 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_433
            c1_434 = TreeSitter.Node.nodeStartPoint node_432
        TreeSitter.Node.TSPoint
            r2_435
            c2_436 = TreeSitter.Node.nodeEndPoint node_432
deriving instance (GHC.Classes.Eq a_437) => GHC.Classes.Eq (LiteralValue a_437)
deriving instance (GHC.Classes.Ord a_438) => GHC.Classes.Ord (LiteralValue a_438)
deriving instance (GHC.Show.Show a_439) => GHC.Show.Show (LiteralValue a_439)
instance AST.Unmarshal.Unmarshal LiteralValue
instance Data.Foldable.Foldable LiteralValue where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor LiteralValue where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable LiteralValue where
    traverse = AST.Traversable1.Class.traverseDefault1
data MapType a = MapType
    { ann :: a
    , value :: (AST.Parse.Err (Type a))
    , key :: (AST.Parse.Err (Type a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_440.
          AST.Traversable1.Class.Traversable1 a_440
        )
instance AST.Unmarshal.SymbolMatching MapType where
    matchedSymbols _ = [122]
    showFailure _ node_441 =
        "expected "
            GHC.Base.<> ( "map_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_441 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_441) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_442 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_443 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_444 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_445 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_442
            c1_443 = TreeSitter.Node.nodeStartPoint node_441
        TreeSitter.Node.TSPoint
            r2_444
            c2_445 = TreeSitter.Node.nodeEndPoint node_441
deriving instance (GHC.Classes.Eq a_446) => GHC.Classes.Eq (MapType a_446)
deriving instance (GHC.Classes.Ord a_447) => GHC.Classes.Ord (MapType a_447)
deriving instance (GHC.Show.Show a_448) => GHC.Show.Show (MapType a_448)
instance AST.Unmarshal.Unmarshal MapType
instance Data.Foldable.Foldable MapType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor MapType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable MapType where
    traverse = AST.Traversable1.Class.traverseDefault1
data MethodDeclaration a = MethodDeclaration
    { ann :: a
    , body :: (GHC.Maybe.Maybe (AST.Parse.Err (Block a)))
    , receiver :: (AST.Parse.Err (ParameterList a))
    , name :: (AST.Parse.Err (FieldIdentifier a))
    , result :: (GHC.Maybe.Maybe (AST.Parse.Err ((SimpleType GHC.Generics.:+: ParameterList) a)))
    , parameters :: (AST.Parse.Err (ParameterList a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_449.
          AST.Traversable1.Class.Traversable1 a_449
        )
instance AST.Unmarshal.SymbolMatching MethodDeclaration where
    matchedSymbols _ = [102]
    showFailure _ node_450 =
        "expected "
            GHC.Base.<> ( "method_declaration"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_450 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_450) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_451 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_452 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_453 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_454 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_451
            c1_452 = TreeSitter.Node.nodeStartPoint node_450
        TreeSitter.Node.TSPoint
            r2_453
            c2_454 = TreeSitter.Node.nodeEndPoint node_450
deriving instance (GHC.Classes.Eq a_455) => GHC.Classes.Eq (MethodDeclaration a_455)
deriving instance (GHC.Classes.Ord a_456) => GHC.Classes.Ord (MethodDeclaration a_456)
deriving instance (GHC.Show.Show a_457) => GHC.Show.Show (MethodDeclaration a_457)
instance AST.Unmarshal.Unmarshal MethodDeclaration
instance Data.Foldable.Foldable MethodDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor MethodDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable MethodDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
data MethodElem a = MethodElem
    { ann :: a
    , name :: (AST.Parse.Err (FieldIdentifier a))
    , result :: (GHC.Maybe.Maybe (AST.Parse.Err ((SimpleType GHC.Generics.:+: ParameterList) a)))
    , parameters :: (AST.Parse.Err (ParameterList a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_458.
          AST.Traversable1.Class.Traversable1 a_458
        )
instance AST.Unmarshal.SymbolMatching MethodElem where
    matchedSymbols _ = []
    showFailure _ node_459 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_459 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_459) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_460 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_461 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_462 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_463 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_460
            c1_461 = TreeSitter.Node.nodeStartPoint node_459
        TreeSitter.Node.TSPoint
            r2_462
            c2_463 = TreeSitter.Node.nodeEndPoint node_459
deriving instance (GHC.Classes.Eq a_464) => GHC.Classes.Eq (MethodElem a_464)
deriving instance (GHC.Classes.Ord a_465) => GHC.Classes.Ord (MethodElem a_465)
deriving instance (GHC.Show.Show a_466) => GHC.Show.Show (MethodElem a_466)
instance AST.Unmarshal.Unmarshal MethodElem
instance Data.Foldable.Foldable MethodElem where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor MethodElem where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable MethodElem where
    traverse = AST.Traversable1.Class.traverseDefault1
data NegatedType a = NegatedType {ann :: a, extraChildren :: (AST.Parse.Err (Type a))}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_467.
          AST.Traversable1.Class.Traversable1 a_467
        )
instance AST.Unmarshal.SymbolMatching NegatedType where
    matchedSymbols _ = []
    showFailure _ node_468 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_468 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_468) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_469 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_470 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_471 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_472 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_469
            c1_470 = TreeSitter.Node.nodeStartPoint node_468
        TreeSitter.Node.TSPoint
            r2_471
            c2_472 = TreeSitter.Node.nodeEndPoint node_468
deriving instance (GHC.Classes.Eq a_473) => GHC.Classes.Eq (NegatedType a_473)
deriving instance (GHC.Classes.Ord a_474) => GHC.Classes.Ord (NegatedType a_474)
deriving instance (GHC.Show.Show a_475) => GHC.Show.Show (NegatedType a_475)
instance AST.Unmarshal.Unmarshal NegatedType
instance Data.Foldable.Foldable NegatedType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor NegatedType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable NegatedType where
    traverse = AST.Traversable1.Class.traverseDefault1
data PackageClause a = PackageClause
    { ann :: a
    , extraChildren :: (AST.Parse.Err (PackageIdentifier a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_476.
          AST.Traversable1.Class.Traversable1 a_476
        )
instance AST.Unmarshal.SymbolMatching PackageClause where
    matchedSymbols _ = [91]
    showFailure _ node_477 =
        "expected "
            GHC.Base.<> ( "package_clause"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_477 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_477) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_478 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_479 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_480 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_481 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_478
            c1_479 = TreeSitter.Node.nodeStartPoint node_477
        TreeSitter.Node.TSPoint
            r2_480
            c2_481 = TreeSitter.Node.nodeEndPoint node_477
deriving instance (GHC.Classes.Eq a_482) => GHC.Classes.Eq (PackageClause a_482)
deriving instance (GHC.Classes.Ord a_483) => GHC.Classes.Ord (PackageClause a_483)
deriving instance (GHC.Show.Show a_484) => GHC.Show.Show (PackageClause a_484)
instance AST.Unmarshal.Unmarshal PackageClause
instance Data.Foldable.Foldable PackageClause where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor PackageClause where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable PackageClause where
    traverse = AST.Traversable1.Class.traverseDefault1
data ParameterDeclaration a = ParameterDeclaration
    { ann :: a
    , name :: ([AST.Parse.Err (Identifier a)])
    , type' :: (AST.Parse.Err (Type a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_485.
          AST.Traversable1.Class.Traversable1 a_485
        )
instance AST.Unmarshal.SymbolMatching ParameterDeclaration where
    matchedSymbols _ = [104]
    showFailure _ node_486 =
        "expected "
            GHC.Base.<> ( "parameter_declaration"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_486 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_486) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_487 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_488 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_489 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_490 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_487
            c1_488 = TreeSitter.Node.nodeStartPoint node_486
        TreeSitter.Node.TSPoint
            r2_489
            c2_490 = TreeSitter.Node.nodeEndPoint node_486
deriving instance (GHC.Classes.Eq a_491) => GHC.Classes.Eq (ParameterDeclaration a_491)
deriving instance (GHC.Classes.Ord a_492) => GHC.Classes.Ord (ParameterDeclaration a_492)
deriving instance (GHC.Show.Show a_493) => GHC.Show.Show (ParameterDeclaration a_493)
instance AST.Unmarshal.Unmarshal ParameterDeclaration
instance Data.Foldable.Foldable ParameterDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ParameterDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ParameterDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
data ParameterList a = ParameterList
    { ann :: a
    , extraChildren :: ([AST.Parse.Err ((ParameterDeclaration GHC.Generics.:+: VariadicParameterDeclaration) a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_494.
          AST.Traversable1.Class.Traversable1 a_494
        )
instance AST.Unmarshal.SymbolMatching ParameterList where
    matchedSymbols _ = [103]
    showFailure _ node_495 =
        "expected "
            GHC.Base.<> ( "parameter_list"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_495 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_495) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_496 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_497 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_498 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_499 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_496
            c1_497 = TreeSitter.Node.nodeStartPoint node_495
        TreeSitter.Node.TSPoint
            r2_498
            c2_499 = TreeSitter.Node.nodeEndPoint node_495
deriving instance (GHC.Classes.Eq a_500) => GHC.Classes.Eq (ParameterList a_500)
deriving instance (GHC.Classes.Ord a_501) => GHC.Classes.Ord (ParameterList a_501)
deriving instance (GHC.Show.Show a_502) => GHC.Show.Show (ParameterList a_502)
instance AST.Unmarshal.Unmarshal ParameterList
instance Data.Foldable.Foldable ParameterList where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ParameterList where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ParameterList where
    traverse = AST.Traversable1.Class.traverseDefault1
data ParenthesizedExpression a = ParenthesizedExpression
    { ann :: a
    , extraChildren :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_503.
          AST.Traversable1.Class.Traversable1 a_503
        )
instance AST.Unmarshal.SymbolMatching ParenthesizedExpression where
    matchedSymbols _ = [158]
    showFailure _ node_504 =
        "expected "
            GHC.Base.<> ( "parenthesized_expression"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_504 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_504) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_505 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_506 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_507 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_508 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_505
            c1_506 = TreeSitter.Node.nodeStartPoint node_504
        TreeSitter.Node.TSPoint
            r2_507
            c2_508 = TreeSitter.Node.nodeEndPoint node_504
deriving instance (GHC.Classes.Eq a_509) => GHC.Classes.Eq (ParenthesizedExpression a_509)
deriving instance (GHC.Classes.Ord a_510) => GHC.Classes.Ord (ParenthesizedExpression a_510)
deriving instance (GHC.Show.Show a_511) => GHC.Show.Show (ParenthesizedExpression a_511)
instance AST.Unmarshal.Unmarshal ParenthesizedExpression
instance Data.Foldable.Foldable ParenthesizedExpression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ParenthesizedExpression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ParenthesizedExpression where
    traverse = AST.Traversable1.Class.traverseDefault1
data ParenthesizedType a = ParenthesizedType
    { ann :: a
    , extraChildren :: (AST.Parse.Err (Type a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_512.
          AST.Traversable1.Class.Traversable1 a_512
        )
instance AST.Unmarshal.SymbolMatching ParenthesizedType where
    matchedSymbols _ = [110]
    showFailure _ node_513 =
        "expected "
            GHC.Base.<> ( "parenthesized_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_513 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_513) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_514 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_515 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_516 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_517 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_514
            c1_515 = TreeSitter.Node.nodeStartPoint node_513
        TreeSitter.Node.TSPoint
            r2_516
            c2_517 = TreeSitter.Node.nodeEndPoint node_513
deriving instance (GHC.Classes.Eq a_518) => GHC.Classes.Eq (ParenthesizedType a_518)
deriving instance (GHC.Classes.Ord a_519) => GHC.Classes.Ord (ParenthesizedType a_519)
deriving instance (GHC.Show.Show a_520) => GHC.Show.Show (ParenthesizedType a_520)
instance AST.Unmarshal.Unmarshal ParenthesizedType
instance Data.Foldable.Foldable ParenthesizedType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ParenthesizedType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ParenthesizedType where
    traverse = AST.Traversable1.Class.traverseDefault1
data PointerType a = PointerType {ann :: a, extraChildren :: (AST.Parse.Err (Type a))}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_521.
          AST.Traversable1.Class.Traversable1 a_521
        )
instance AST.Unmarshal.SymbolMatching PointerType where
    matchedSymbols _ = [112]
    showFailure _ node_522 =
        "expected "
            GHC.Base.<> ( "pointer_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_522 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_522) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_523 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_524 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_525 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_526 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_523
            c1_524 = TreeSitter.Node.nodeStartPoint node_522
        TreeSitter.Node.TSPoint
            r2_525
            c2_526 = TreeSitter.Node.nodeEndPoint node_522
deriving instance (GHC.Classes.Eq a_527) => GHC.Classes.Eq (PointerType a_527)
deriving instance (GHC.Classes.Ord a_528) => GHC.Classes.Ord (PointerType a_528)
deriving instance (GHC.Show.Show a_529) => GHC.Show.Show (PointerType a_529)
instance AST.Unmarshal.Unmarshal PointerType
instance Data.Foldable.Foldable PointerType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor PointerType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable PointerType where
    traverse = AST.Traversable1.Class.traverseDefault1
data QualifiedType a = QualifiedType
    { ann :: a
    , name :: (AST.Parse.Err (TypeIdentifier a))
    , package :: (AST.Parse.Err (PackageIdentifier a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_530.
          AST.Traversable1.Class.Traversable1 a_530
        )
instance AST.Unmarshal.SymbolMatching QualifiedType where
    matchedSymbols _ = [175]
    showFailure _ node_531 =
        "expected "
            GHC.Base.<> ( "qualified_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_531 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_531) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_532 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_533 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_534 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_535 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_532
            c1_533 = TreeSitter.Node.nodeStartPoint node_531
        TreeSitter.Node.TSPoint
            r2_534
            c2_535 = TreeSitter.Node.nodeEndPoint node_531
deriving instance (GHC.Classes.Eq a_536) => GHC.Classes.Eq (QualifiedType a_536)
deriving instance (GHC.Classes.Ord a_537) => GHC.Classes.Ord (QualifiedType a_537)
deriving instance (GHC.Show.Show a_538) => GHC.Show.Show (QualifiedType a_538)
instance AST.Unmarshal.Unmarshal QualifiedType
instance Data.Foldable.Foldable QualifiedType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor QualifiedType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable QualifiedType where
    traverse = AST.Traversable1.Class.traverseDefault1
data RangeClause a = RangeClause
    { ann :: a
    , left :: (GHC.Maybe.Maybe (AST.Parse.Err (ExpressionList a)))
    , right :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_539.
          AST.Traversable1.Class.Traversable1 a_539
        )
instance AST.Unmarshal.SymbolMatching RangeClause where
    matchedSymbols _ = [148]
    showFailure _ node_540 =
        "expected "
            GHC.Base.<> ( "range_clause"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_540 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_540) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_541 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_542 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_543 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_544 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_541
            c1_542 = TreeSitter.Node.nodeStartPoint node_540
        TreeSitter.Node.TSPoint
            r2_543
            c2_544 = TreeSitter.Node.nodeEndPoint node_540
deriving instance (GHC.Classes.Eq a_545) => GHC.Classes.Eq (RangeClause a_545)
deriving instance (GHC.Classes.Ord a_546) => GHC.Classes.Ord (RangeClause a_546)
deriving instance (GHC.Show.Show a_547) => GHC.Show.Show (RangeClause a_547)
instance AST.Unmarshal.Unmarshal RangeClause
instance Data.Foldable.Foldable RangeClause where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor RangeClause where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable RangeClause where
    traverse = AST.Traversable1.Class.traverseDefault1
data RawStringLiteral a = RawStringLiteral
    { ann :: a
    , extraChildren :: (AST.Parse.Err (RawStringLiteralContent a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_548.
          AST.Traversable1.Class.Traversable1 a_548
        )
instance AST.Unmarshal.SymbolMatching RawStringLiteral where
    matchedSymbols _ = [78]
    showFailure _ node_549 =
        "expected "
            GHC.Base.<> ( "raw_string_literal"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_549 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_549) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_550 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_551 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_552 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_553 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_550
            c1_551 = TreeSitter.Node.nodeStartPoint node_549
        TreeSitter.Node.TSPoint
            r2_552
            c2_553 = TreeSitter.Node.nodeEndPoint node_549
deriving instance (GHC.Classes.Eq a_554) => GHC.Classes.Eq (RawStringLiteral a_554)
deriving instance (GHC.Classes.Ord a_555) => GHC.Classes.Ord (RawStringLiteral a_555)
deriving instance (GHC.Show.Show a_556) => GHC.Show.Show (RawStringLiteral a_556)
instance AST.Unmarshal.Unmarshal RawStringLiteral
instance Data.Foldable.Foldable RawStringLiteral where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor RawStringLiteral where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable RawStringLiteral where
    traverse = AST.Traversable1.Class.traverseDefault1
data ReceiveStatement a = ReceiveStatement
    { ann :: a
    , left :: (GHC.Maybe.Maybe (AST.Parse.Err (ExpressionList a)))
    , right :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_557.
          AST.Traversable1.Class.Traversable1 a_557
        )
instance AST.Unmarshal.SymbolMatching ReceiveStatement where
    matchedSymbols _ = [131]
    showFailure _ node_558 =
        "expected "
            GHC.Base.<> ( "receive_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_558 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_558) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_559 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_560 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_561 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_562 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_559
            c1_560 = TreeSitter.Node.nodeStartPoint node_558
        TreeSitter.Node.TSPoint
            r2_561
            c2_562 = TreeSitter.Node.nodeEndPoint node_558
deriving instance (GHC.Classes.Eq a_563) => GHC.Classes.Eq (ReceiveStatement a_563)
deriving instance (GHC.Classes.Ord a_564) => GHC.Classes.Ord (ReceiveStatement a_564)
deriving instance (GHC.Show.Show a_565) => GHC.Show.Show (ReceiveStatement a_565)
instance AST.Unmarshal.Unmarshal ReceiveStatement
instance Data.Foldable.Foldable ReceiveStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ReceiveStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ReceiveStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data ReturnStatement a = ReturnStatement
    { ann :: a
    , extraChildren :: (GHC.Maybe.Maybe (AST.Parse.Err (ExpressionList a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_566.
          AST.Traversable1.Class.Traversable1 a_566
        )
instance AST.Unmarshal.SymbolMatching ReturnStatement where
    matchedSymbols _ = [142]
    showFailure _ node_567 =
        "expected "
            GHC.Base.<> ( "return_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_567 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_567) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_568 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_569 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_570 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_571 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_568
            c1_569 = TreeSitter.Node.nodeStartPoint node_567
        TreeSitter.Node.TSPoint
            r2_570
            c2_571 = TreeSitter.Node.nodeEndPoint node_567
deriving instance (GHC.Classes.Eq a_572) => GHC.Classes.Eq (ReturnStatement a_572)
deriving instance (GHC.Classes.Ord a_573) => GHC.Classes.Ord (ReturnStatement a_573)
deriving instance (GHC.Show.Show a_574) => GHC.Show.Show (ReturnStatement a_574)
instance AST.Unmarshal.Unmarshal ReturnStatement
instance Data.Foldable.Foldable ReturnStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ReturnStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ReturnStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data SelectStatement a = SelectStatement
    { ann :: a
    , extraChildren :: ([AST.Parse.Err ((CommunicationCase GHC.Generics.:+: DefaultCase) a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_575.
          AST.Traversable1.Class.Traversable1 a_575
        )
instance AST.Unmarshal.SymbolMatching SelectStatement where
    matchedSymbols _ = [155]
    showFailure _ node_576 =
        "expected "
            GHC.Base.<> ( "select_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_576 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_576) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_577 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_578 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_579 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_580 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_577
            c1_578 = TreeSitter.Node.nodeStartPoint node_576
        TreeSitter.Node.TSPoint
            r2_579
            c2_580 = TreeSitter.Node.nodeEndPoint node_576
deriving instance (GHC.Classes.Eq a_581) => GHC.Classes.Eq (SelectStatement a_581)
deriving instance (GHC.Classes.Ord a_582) => GHC.Classes.Ord (SelectStatement a_582)
deriving instance (GHC.Show.Show a_583) => GHC.Show.Show (SelectStatement a_583)
instance AST.Unmarshal.Unmarshal SelectStatement
instance Data.Foldable.Foldable SelectStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor SelectStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable SelectStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data SelectorExpression a = SelectorExpression
    { ann :: a
    , field :: (AST.Parse.Err (FieldIdentifier a))
    , operand :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_584.
          AST.Traversable1.Class.Traversable1 a_584
        )
instance AST.Unmarshal.SymbolMatching SelectorExpression where
    matchedSymbols _ = [163]
    showFailure _ node_585 =
        "expected "
            GHC.Base.<> ( "selector_expression"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_585 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_585) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_586 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_587 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_588 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_589 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_586
            c1_587 = TreeSitter.Node.nodeStartPoint node_585
        TreeSitter.Node.TSPoint
            r2_588
            c2_589 = TreeSitter.Node.nodeEndPoint node_585
deriving instance (GHC.Classes.Eq a_590) => GHC.Classes.Eq (SelectorExpression a_590)
deriving instance (GHC.Classes.Ord a_591) => GHC.Classes.Ord (SelectorExpression a_591)
deriving instance (GHC.Show.Show a_592) => GHC.Show.Show (SelectorExpression a_592)
instance AST.Unmarshal.Unmarshal SelectorExpression
instance Data.Foldable.Foldable SelectorExpression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor SelectorExpression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable SelectorExpression where
    traverse = AST.Traversable1.Class.traverseDefault1
data SendStatement a = SendStatement
    { ann :: a
    , value :: (AST.Parse.Err (Expression a))
    , channel :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_593.
          AST.Traversable1.Class.Traversable1 a_593
        )
instance AST.Unmarshal.SymbolMatching SendStatement where
    matchedSymbols _ = [130]
    showFailure _ node_594 =
        "expected "
            GHC.Base.<> ( "send_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_594 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_594) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_595 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_596 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_597 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_598 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_595
            c1_596 = TreeSitter.Node.nodeStartPoint node_594
        TreeSitter.Node.TSPoint
            r2_597
            c2_598 = TreeSitter.Node.nodeEndPoint node_594
deriving instance (GHC.Classes.Eq a_599) => GHC.Classes.Eq (SendStatement a_599)
deriving instance (GHC.Classes.Ord a_600) => GHC.Classes.Ord (SendStatement a_600)
deriving instance (GHC.Show.Show a_601) => GHC.Show.Show (SendStatement a_601)
instance AST.Unmarshal.Unmarshal SendStatement
instance Data.Foldable.Foldable SendStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor SendStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable SendStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data ShortVarDeclaration a = ShortVarDeclaration
    { ann :: a
    , left :: (AST.Parse.Err (ExpressionList a))
    , right :: (AST.Parse.Err (ExpressionList a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_602.
          AST.Traversable1.Class.Traversable1 a_602
        )
instance AST.Unmarshal.SymbolMatching ShortVarDeclaration where
    matchedSymbols _ = [135]
    showFailure _ node_603 =
        "expected "
            GHC.Base.<> ( "short_var_declaration"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_603 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_603) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_604 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_605 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_606 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_607 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_604
            c1_605 = TreeSitter.Node.nodeStartPoint node_603
        TreeSitter.Node.TSPoint
            r2_606
            c2_607 = TreeSitter.Node.nodeEndPoint node_603
deriving instance (GHC.Classes.Eq a_608) => GHC.Classes.Eq (ShortVarDeclaration a_608)
deriving instance (GHC.Classes.Ord a_609) => GHC.Classes.Ord (ShortVarDeclaration a_609)
deriving instance (GHC.Show.Show a_610) => GHC.Show.Show (ShortVarDeclaration a_610)
instance AST.Unmarshal.Unmarshal ShortVarDeclaration
instance Data.Foldable.Foldable ShortVarDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ShortVarDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ShortVarDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
data SliceExpression a = SliceExpression
    { ann :: a
    , capacity :: (GHC.Maybe.Maybe (AST.Parse.Err (Expression a)))
    , end :: (GHC.Maybe.Maybe (AST.Parse.Err (Expression a)))
    , start :: (GHC.Maybe.Maybe (AST.Parse.Err (Expression a)))
    , operand :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_611.
          AST.Traversable1.Class.Traversable1 a_611
        )
instance AST.Unmarshal.SymbolMatching SliceExpression where
    matchedSymbols _ = [165]
    showFailure _ node_612 =
        "expected "
            GHC.Base.<> ( "slice_expression"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_612 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_612) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_613 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_614 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_615 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_616 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_613
            c1_614 = TreeSitter.Node.nodeStartPoint node_612
        TreeSitter.Node.TSPoint
            r2_615
            c2_616 = TreeSitter.Node.nodeEndPoint node_612
deriving instance (GHC.Classes.Eq a_617) => GHC.Classes.Eq (SliceExpression a_617)
deriving instance (GHC.Classes.Ord a_618) => GHC.Classes.Ord (SliceExpression a_618)
deriving instance (GHC.Show.Show a_619) => GHC.Show.Show (SliceExpression a_619)
instance AST.Unmarshal.Unmarshal SliceExpression
instance Data.Foldable.Foldable SliceExpression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor SliceExpression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable SliceExpression where
    traverse = AST.Traversable1.Class.traverseDefault1
data SliceType a = SliceType {ann :: a, element :: (AST.Parse.Err (Type a))}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_620.
          AST.Traversable1.Class.Traversable1 a_620
        )
instance AST.Unmarshal.SymbolMatching SliceType where
    matchedSymbols _ = [115]
    showFailure _ node_621 =
        "expected "
            GHC.Base.<> ( "slice_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_621 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_621) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_622 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_623 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_624 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_625 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_622
            c1_623 = TreeSitter.Node.nodeStartPoint node_621
        TreeSitter.Node.TSPoint
            r2_624
            c2_625 = TreeSitter.Node.nodeEndPoint node_621
deriving instance (GHC.Classes.Eq a_626) => GHC.Classes.Eq (SliceType a_626)
deriving instance (GHC.Classes.Ord a_627) => GHC.Classes.Ord (SliceType a_627)
deriving instance (GHC.Show.Show a_628) => GHC.Show.Show (SliceType a_628)
instance AST.Unmarshal.Unmarshal SliceType
instance Data.Foldable.Foldable SliceType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor SliceType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable SliceType where
    traverse = AST.Traversable1.Class.traverseDefault1
data SourceFile a = SourceFile
    { ann :: a
    , extraChildren :: ([AST.Parse.Err ((Statement GHC.Generics.:+: FunctionDeclaration GHC.Generics.:+: ImportDeclaration GHC.Generics.:+: MethodDeclaration GHC.Generics.:+: PackageClause) a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_629.
          AST.Traversable1.Class.Traversable1 a_629
        )
instance AST.Unmarshal.SymbolMatching SourceFile where
    matchedSymbols _ = [90]
    showFailure _ node_630 =
        "expected "
            GHC.Base.<> ( "source_file"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_630 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_630) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_631 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_632 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_633 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_634 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_631
            c1_632 = TreeSitter.Node.nodeStartPoint node_630
        TreeSitter.Node.TSPoint
            r2_633
            c2_634 = TreeSitter.Node.nodeEndPoint node_630
deriving instance (GHC.Classes.Eq a_635) => GHC.Classes.Eq (SourceFile a_635)
deriving instance (GHC.Classes.Ord a_636) => GHC.Classes.Ord (SourceFile a_636)
deriving instance (GHC.Show.Show a_637) => GHC.Show.Show (SourceFile a_637)
instance AST.Unmarshal.Unmarshal SourceFile
instance Data.Foldable.Foldable SourceFile where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor SourceFile where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable SourceFile where
    traverse = AST.Traversable1.Class.traverseDefault1
data StructType a = StructType
    { ann :: a
    , extraChildren :: (AST.Parse.Err (FieldDeclarationList a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_638.
          AST.Traversable1.Class.Traversable1 a_638
        )
instance AST.Unmarshal.SymbolMatching StructType where
    matchedSymbols _ = [116]
    showFailure _ node_639 =
        "expected "
            GHC.Base.<> ( "struct_type"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_639 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_639) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_640 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_641 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_642 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_643 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_640
            c1_641 = TreeSitter.Node.nodeStartPoint node_639
        TreeSitter.Node.TSPoint
            r2_642
            c2_643 = TreeSitter.Node.nodeEndPoint node_639
deriving instance (GHC.Classes.Eq a_644) => GHC.Classes.Eq (StructType a_644)
deriving instance (GHC.Classes.Ord a_645) => GHC.Classes.Ord (StructType a_645)
deriving instance (GHC.Show.Show a_646) => GHC.Show.Show (StructType a_646)
instance AST.Unmarshal.Unmarshal StructType
instance Data.Foldable.Foldable StructType where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor StructType where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable StructType where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeAlias a = TypeAlias
    { ann :: a
    , name :: (AST.Parse.Err (TypeIdentifier a))
    , type' :: (AST.Parse.Err (Type a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_647.
          AST.Traversable1.Class.Traversable1 a_647
        )
instance AST.Unmarshal.SymbolMatching TypeAlias where
    matchedSymbols _ = [106]
    showFailure _ node_648 =
        "expected "
            GHC.Base.<> ( "type_alias"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_648 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_648) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_649 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_650 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_651 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_652 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_649
            c1_650 = TreeSitter.Node.nodeStartPoint node_648
        TreeSitter.Node.TSPoint
            r2_651
            c2_652 = TreeSitter.Node.nodeEndPoint node_648
deriving instance (GHC.Classes.Eq a_653) => GHC.Classes.Eq (TypeAlias a_653)
deriving instance (GHC.Classes.Ord a_654) => GHC.Classes.Ord (TypeAlias a_654)
deriving instance (GHC.Show.Show a_655) => GHC.Show.Show (TypeAlias a_655)
instance AST.Unmarshal.Unmarshal TypeAlias
instance Data.Foldable.Foldable TypeAlias where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeAlias where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeAlias where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeArguments a = TypeArguments
    { ann :: a
    , extraChildren :: (GHC.Base.NonEmpty (AST.Parse.Err (TypeElem a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_656.
          AST.Traversable1.Class.Traversable1 a_656
        )
instance AST.Unmarshal.SymbolMatching TypeArguments where
    matchedSymbols _ = []
    showFailure _ node_657 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_657 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_657) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_658 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_659 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_660 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_661 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_658
            c1_659 = TreeSitter.Node.nodeStartPoint node_657
        TreeSitter.Node.TSPoint
            r2_660
            c2_661 = TreeSitter.Node.nodeEndPoint node_657
deriving instance (GHC.Classes.Eq a_662) => GHC.Classes.Eq (TypeArguments a_662)
deriving instance (GHC.Classes.Ord a_663) => GHC.Classes.Ord (TypeArguments a_663)
deriving instance (GHC.Show.Show a_664) => GHC.Show.Show (TypeArguments a_664)
instance AST.Unmarshal.Unmarshal TypeArguments
instance Data.Foldable.Foldable TypeArguments where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeArguments where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeArguments where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeAssertionExpression a = TypeAssertionExpression
    { ann :: a
    , type' :: (AST.Parse.Err (Type a))
    , operand :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_665.
          AST.Traversable1.Class.Traversable1 a_665
        )
instance AST.Unmarshal.SymbolMatching TypeAssertionExpression where
    matchedSymbols _ = [166]
    showFailure _ node_666 =
        "expected "
            GHC.Base.<> ( "type_assertion_expression"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_666 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_666) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_667 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_668 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_669 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_670 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_667
            c1_668 = TreeSitter.Node.nodeStartPoint node_666
        TreeSitter.Node.TSPoint
            r2_669
            c2_670 = TreeSitter.Node.nodeEndPoint node_666
deriving instance (GHC.Classes.Eq a_671) => GHC.Classes.Eq (TypeAssertionExpression a_671)
deriving instance (GHC.Classes.Ord a_672) => GHC.Classes.Ord (TypeAssertionExpression a_672)
deriving instance (GHC.Show.Show a_673) => GHC.Show.Show (TypeAssertionExpression a_673)
instance AST.Unmarshal.Unmarshal TypeAssertionExpression
instance Data.Foldable.Foldable TypeAssertionExpression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeAssertionExpression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeAssertionExpression where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeCase a = TypeCase
    { ann :: a
    , type' :: (GHC.Base.NonEmpty (AST.Parse.Err ((AnonymousComma GHC.Generics.:+: Type) a)))
    , extraChildren :: ([AST.Parse.Err (Statement a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_674.
          AST.Traversable1.Class.Traversable1 a_674
        )
instance AST.Unmarshal.SymbolMatching TypeCase where
    matchedSymbols _ = [154]
    showFailure _ node_675 =
        "expected "
            GHC.Base.<> ( "type_case"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_675 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_675) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_676 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_677 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_678 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_679 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_676
            c1_677 = TreeSitter.Node.nodeStartPoint node_675
        TreeSitter.Node.TSPoint
            r2_678
            c2_679 = TreeSitter.Node.nodeEndPoint node_675
deriving instance (GHC.Classes.Eq a_680) => GHC.Classes.Eq (TypeCase a_680)
deriving instance (GHC.Classes.Ord a_681) => GHC.Classes.Ord (TypeCase a_681)
deriving instance (GHC.Show.Show a_682) => GHC.Show.Show (TypeCase a_682)
instance AST.Unmarshal.Unmarshal TypeCase
instance Data.Foldable.Foldable TypeCase where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeCase where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeCase where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeConstraint a = TypeConstraint
    { ann :: a
    , extraChildren :: (GHC.Base.NonEmpty (AST.Parse.Err (Type a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_683.
          AST.Traversable1.Class.Traversable1 a_683
        )
instance AST.Unmarshal.SymbolMatching TypeConstraint where
    matchedSymbols _ = []
    showFailure _ node_684 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_684 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_684) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_685 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_686 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_687 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_688 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_685
            c1_686 = TreeSitter.Node.nodeStartPoint node_684
        TreeSitter.Node.TSPoint
            r2_687
            c2_688 = TreeSitter.Node.nodeEndPoint node_684
deriving instance (GHC.Classes.Eq a_689) => GHC.Classes.Eq (TypeConstraint a_689)
deriving instance (GHC.Classes.Ord a_690) => GHC.Classes.Ord (TypeConstraint a_690)
deriving instance (GHC.Show.Show a_691) => GHC.Show.Show (TypeConstraint a_691)
instance AST.Unmarshal.Unmarshal TypeConstraint
instance Data.Foldable.Foldable TypeConstraint where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeConstraint where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeConstraint where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeConversionExpression a = TypeConversionExpression
    { ann :: a
    , type' :: (AST.Parse.Err (Type a))
    , operand :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_692.
          AST.Traversable1.Class.Traversable1 a_692
        )
instance AST.Unmarshal.SymbolMatching TypeConversionExpression where
    matchedSymbols _ = [167]
    showFailure _ node_693 =
        "expected "
            GHC.Base.<> ( "type_conversion_expression"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_693 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_693) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_694 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_695 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_696 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_697 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_694
            c1_695 = TreeSitter.Node.nodeStartPoint node_693
        TreeSitter.Node.TSPoint
            r2_696
            c2_697 = TreeSitter.Node.nodeEndPoint node_693
deriving instance (GHC.Classes.Eq a_698) => GHC.Classes.Eq (TypeConversionExpression a_698)
deriving instance (GHC.Classes.Ord a_699) => GHC.Classes.Ord (TypeConversionExpression a_699)
deriving instance (GHC.Show.Show a_700) => GHC.Show.Show (TypeConversionExpression a_700)
instance AST.Unmarshal.Unmarshal TypeConversionExpression
instance Data.Foldable.Foldable TypeConversionExpression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeConversionExpression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeConversionExpression where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeDeclaration a = TypeDeclaration
    { ann :: a
    , extraChildren :: ([AST.Parse.Err ((TypeAlias GHC.Generics.:+: TypeSpec) a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_701.
          AST.Traversable1.Class.Traversable1 a_701
        )
instance AST.Unmarshal.SymbolMatching TypeDeclaration where
    matchedSymbols _ = [107]
    showFailure _ node_702 =
        "expected "
            GHC.Base.<> ( "type_declaration"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_702 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_702) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_703 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_704 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_705 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_706 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_703
            c1_704 = TreeSitter.Node.nodeStartPoint node_702
        TreeSitter.Node.TSPoint
            r2_705
            c2_706 = TreeSitter.Node.nodeEndPoint node_702
deriving instance (GHC.Classes.Eq a_707) => GHC.Classes.Eq (TypeDeclaration a_707)
deriving instance (GHC.Classes.Ord a_708) => GHC.Classes.Ord (TypeDeclaration a_708)
deriving instance (GHC.Show.Show a_709) => GHC.Show.Show (TypeDeclaration a_709)
instance AST.Unmarshal.Unmarshal TypeDeclaration
instance Data.Foldable.Foldable TypeDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeElem a = TypeElem
    { ann :: a
    , extraChildren :: (GHC.Base.NonEmpty (AST.Parse.Err (Type a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_710.
          AST.Traversable1.Class.Traversable1 a_710
        )
instance AST.Unmarshal.SymbolMatching TypeElem where
    matchedSymbols _ = []
    showFailure _ node_711 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_711 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_711) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_712 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_713 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_714 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_715 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_712
            c1_713 = TreeSitter.Node.nodeStartPoint node_711
        TreeSitter.Node.TSPoint
            r2_714
            c2_715 = TreeSitter.Node.nodeEndPoint node_711
deriving instance (GHC.Classes.Eq a_716) => GHC.Classes.Eq (TypeElem a_716)
deriving instance (GHC.Classes.Ord a_717) => GHC.Classes.Ord (TypeElem a_717)
deriving instance (GHC.Show.Show a_718) => GHC.Show.Show (TypeElem a_718)
instance AST.Unmarshal.Unmarshal TypeElem
instance Data.Foldable.Foldable TypeElem where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeElem where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeElem where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeInstantiationExpression a = TypeInstantiationExpression
    { ann :: a
    , type' :: (AST.Parse.Err (Type a))
    , extraChildren :: (GHC.Base.NonEmpty (AST.Parse.Err (Type a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_719.
          AST.Traversable1.Class.Traversable1 a_719
        )
instance AST.Unmarshal.SymbolMatching TypeInstantiationExpression where
    matchedSymbols _ = []
    showFailure _ node_720 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_720 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_720) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_721 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_722 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_723 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_724 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_721
            c1_722 = TreeSitter.Node.nodeStartPoint node_720
        TreeSitter.Node.TSPoint
            r2_723
            c2_724 = TreeSitter.Node.nodeEndPoint node_720
deriving instance (GHC.Classes.Eq a_725) => GHC.Classes.Eq (TypeInstantiationExpression a_725)
deriving instance (GHC.Classes.Ord a_726) => GHC.Classes.Ord (TypeInstantiationExpression a_726)
deriving instance (GHC.Show.Show a_727) => GHC.Show.Show (TypeInstantiationExpression a_727)
instance AST.Unmarshal.Unmarshal TypeInstantiationExpression
instance Data.Foldable.Foldable TypeInstantiationExpression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeInstantiationExpression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeInstantiationExpression where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeParameterDeclaration a = TypeParameterDeclaration
    { ann :: a
    , name :: (GHC.Base.NonEmpty (AST.Parse.Err (Identifier a)))
    , type' :: (AST.Parse.Err (TypeConstraint a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_728.
          AST.Traversable1.Class.Traversable1 a_728
        )
instance AST.Unmarshal.SymbolMatching TypeParameterDeclaration where
    matchedSymbols _ = []
    showFailure _ node_729 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_729 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_729) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_730 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_731 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_732 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_733 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_730
            c1_731 = TreeSitter.Node.nodeStartPoint node_729
        TreeSitter.Node.TSPoint
            r2_732
            c2_733 = TreeSitter.Node.nodeEndPoint node_729
deriving instance (GHC.Classes.Eq a_734) => GHC.Classes.Eq (TypeParameterDeclaration a_734)
deriving instance (GHC.Classes.Ord a_735) => GHC.Classes.Ord (TypeParameterDeclaration a_735)
deriving instance (GHC.Show.Show a_736) => GHC.Show.Show (TypeParameterDeclaration a_736)
instance AST.Unmarshal.Unmarshal TypeParameterDeclaration
instance Data.Foldable.Foldable TypeParameterDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeParameterDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeParameterDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeParameterList a = TypeParameterList
    { ann :: a
    , extraChildren :: (GHC.Base.NonEmpty (AST.Parse.Err (TypeParameterDeclaration a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_737.
          AST.Traversable1.Class.Traversable1 a_737
        )
instance AST.Unmarshal.SymbolMatching TypeParameterList where
    matchedSymbols _ = []
    showFailure _ node_738 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_738 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_738) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_739 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_740 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_741 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_742 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_739
            c1_740 = TreeSitter.Node.nodeStartPoint node_738
        TreeSitter.Node.TSPoint
            r2_741
            c2_742 = TreeSitter.Node.nodeEndPoint node_738
deriving instance (GHC.Classes.Eq a_743) => GHC.Classes.Eq (TypeParameterList a_743)
deriving instance (GHC.Classes.Ord a_744) => GHC.Classes.Ord (TypeParameterList a_744)
deriving instance (GHC.Show.Show a_745) => GHC.Show.Show (TypeParameterList a_745)
instance AST.Unmarshal.Unmarshal TypeParameterList
instance Data.Foldable.Foldable TypeParameterList where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeParameterList where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeParameterList where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeSpec a = TypeSpec
    { ann :: a
    , typeParameters :: (GHC.Maybe.Maybe (AST.Parse.Err (TypeParameterList a)))
    , name :: (AST.Parse.Err (TypeIdentifier a))
    , type' :: (AST.Parse.Err (Type a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_746.
          AST.Traversable1.Class.Traversable1 a_746
        )
instance AST.Unmarshal.SymbolMatching TypeSpec where
    matchedSymbols _ = [108]
    showFailure _ node_747 =
        "expected "
            GHC.Base.<> ( "type_spec"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_747 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_747) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_748 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_749 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_750 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_751 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_748
            c1_749 = TreeSitter.Node.nodeStartPoint node_747
        TreeSitter.Node.TSPoint
            r2_750
            c2_751 = TreeSitter.Node.nodeEndPoint node_747
deriving instance (GHC.Classes.Eq a_752) => GHC.Classes.Eq (TypeSpec a_752)
deriving instance (GHC.Classes.Ord a_753) => GHC.Classes.Ord (TypeSpec a_753)
deriving instance (GHC.Show.Show a_754) => GHC.Show.Show (TypeSpec a_754)
instance AST.Unmarshal.Unmarshal TypeSpec
instance Data.Foldable.Foldable TypeSpec where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeSpec where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeSpec where
    traverse = AST.Traversable1.Class.traverseDefault1
data TypeSwitchStatement a = TypeSwitchStatement
    { ann :: a
    , value :: (AST.Parse.Err (Expression a))
    , alias :: (GHC.Maybe.Maybe (AST.Parse.Err (ExpressionList a)))
    , initializer :: (GHC.Maybe.Maybe (AST.Parse.Err (SimpleStatement a)))
    , extraChildren :: ([AST.Parse.Err ((DefaultCase GHC.Generics.:+: TypeCase) a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_755.
          AST.Traversable1.Class.Traversable1 a_755
        )
instance AST.Unmarshal.SymbolMatching TypeSwitchStatement where
    matchedSymbols _ = [152]
    showFailure _ node_756 =
        "expected "
            GHC.Base.<> ( "type_switch_statement"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_756 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_756) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_757 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_758 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_759 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_760 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_757
            c1_758 = TreeSitter.Node.nodeStartPoint node_756
        TreeSitter.Node.TSPoint
            r2_759
            c2_760 = TreeSitter.Node.nodeEndPoint node_756
deriving instance (GHC.Classes.Eq a_761) => GHC.Classes.Eq (TypeSwitchStatement a_761)
deriving instance (GHC.Classes.Ord a_762) => GHC.Classes.Ord (TypeSwitchStatement a_762)
deriving instance (GHC.Show.Show a_763) => GHC.Show.Show (TypeSwitchStatement a_763)
instance AST.Unmarshal.Unmarshal TypeSwitchStatement
instance Data.Foldable.Foldable TypeSwitchStatement where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeSwitchStatement where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeSwitchStatement where
    traverse = AST.Traversable1.Class.traverseDefault1
data UnaryExpression a = UnaryExpression
    { ann :: a
    , operator :: (AST.Parse.Err ((AnonymousBang GHC.Generics.:+: AnonymousAmpersand GHC.Generics.:+: AnonymousStar GHC.Generics.:+: AnonymousPlus GHC.Generics.:+: AnonymousMinus GHC.Generics.:+: AnonymousLAngleMinus GHC.Generics.:+: AnonymousCaret) a))
    , operand :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_764.
          AST.Traversable1.Class.Traversable1 a_764
        )
instance AST.Unmarshal.SymbolMatching UnaryExpression where
    matchedSymbols _ = [173]
    showFailure _ node_765 =
        "expected "
            GHC.Base.<> ( "unary_expression"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_765 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_765) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_766 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_767 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_768 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_769 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_766
            c1_767 = TreeSitter.Node.nodeStartPoint node_765
        TreeSitter.Node.TSPoint
            r2_768
            c2_769 = TreeSitter.Node.nodeEndPoint node_765
deriving instance (GHC.Classes.Eq a_770) => GHC.Classes.Eq (UnaryExpression a_770)
deriving instance (GHC.Classes.Ord a_771) => GHC.Classes.Ord (UnaryExpression a_771)
deriving instance (GHC.Show.Show a_772) => GHC.Show.Show (UnaryExpression a_772)
instance AST.Unmarshal.Unmarshal UnaryExpression
instance Data.Foldable.Foldable UnaryExpression where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor UnaryExpression where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable UnaryExpression where
    traverse = AST.Traversable1.Class.traverseDefault1
data VarDeclaration a = VarDeclaration
    { ann :: a
    , extraChildren :: (AST.Parse.Err ((VarSpec GHC.Generics.:+: VarSpecList) a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_773.
          AST.Traversable1.Class.Traversable1 a_773
        )
instance AST.Unmarshal.SymbolMatching VarDeclaration where
    matchedSymbols _ = [99]
    showFailure _ node_774 =
        "expected "
            GHC.Base.<> ( "var_declaration"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_774 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_774) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_775 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_776 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_777 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_778 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_775
            c1_776 = TreeSitter.Node.nodeStartPoint node_774
        TreeSitter.Node.TSPoint
            r2_777
            c2_778 = TreeSitter.Node.nodeEndPoint node_774
deriving instance (GHC.Classes.Eq a_779) => GHC.Classes.Eq (VarDeclaration a_779)
deriving instance (GHC.Classes.Ord a_780) => GHC.Classes.Ord (VarDeclaration a_780)
deriving instance (GHC.Show.Show a_781) => GHC.Show.Show (VarDeclaration a_781)
instance AST.Unmarshal.Unmarshal VarDeclaration
instance Data.Foldable.Foldable VarDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor VarDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable VarDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
data VarSpec a = VarSpec
    { ann :: a
    , value :: (GHC.Maybe.Maybe (AST.Parse.Err (ExpressionList a)))
    , name :: (GHC.Base.NonEmpty (AST.Parse.Err (Identifier a)))
    , type' :: (GHC.Maybe.Maybe (AST.Parse.Err (Type a)))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_782.
          AST.Traversable1.Class.Traversable1 a_782
        )
instance AST.Unmarshal.SymbolMatching VarSpec where
    matchedSymbols _ = [100]
    showFailure _ node_783 =
        "expected "
            GHC.Base.<> ( "var_spec"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_783 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_783) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_784 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_785 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_786 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_787 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_784
            c1_785 = TreeSitter.Node.nodeStartPoint node_783
        TreeSitter.Node.TSPoint
            r2_786
            c2_787 = TreeSitter.Node.nodeEndPoint node_783
deriving instance (GHC.Classes.Eq a_788) => GHC.Classes.Eq (VarSpec a_788)
deriving instance (GHC.Classes.Ord a_789) => GHC.Classes.Ord (VarSpec a_789)
deriving instance (GHC.Show.Show a_790) => GHC.Show.Show (VarSpec a_790)
instance AST.Unmarshal.Unmarshal VarSpec
instance Data.Foldable.Foldable VarSpec where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor VarSpec where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable VarSpec where
    traverse = AST.Traversable1.Class.traverseDefault1
data VarSpecList a = VarSpecList
    { ann :: a
    , extraChildren :: ([AST.Parse.Err (VarSpec a)])
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_791.
          AST.Traversable1.Class.Traversable1 a_791
        )
instance AST.Unmarshal.SymbolMatching VarSpecList where
    matchedSymbols _ = []
    showFailure _ node_792 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_792 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_792) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_793 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_794 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_795 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_796 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_793
            c1_794 = TreeSitter.Node.nodeStartPoint node_792
        TreeSitter.Node.TSPoint
            r2_795
            c2_796 = TreeSitter.Node.nodeEndPoint node_792
deriving instance (GHC.Classes.Eq a_797) => GHC.Classes.Eq (VarSpecList a_797)
deriving instance (GHC.Classes.Ord a_798) => GHC.Classes.Ord (VarSpecList a_798)
deriving instance (GHC.Show.Show a_799) => GHC.Show.Show (VarSpecList a_799)
instance AST.Unmarshal.Unmarshal VarSpecList
instance Data.Foldable.Foldable VarSpecList where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor VarSpecList where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable VarSpecList where
    traverse = AST.Traversable1.Class.traverseDefault1
data VariadicArgument a = VariadicArgument
    { ann :: a
    , extraChildren :: (AST.Parse.Err (Expression a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_800.
          AST.Traversable1.Class.Traversable1 a_800
        )
instance AST.Unmarshal.SymbolMatching VariadicArgument where
    matchedSymbols _ = [160]
    showFailure _ node_801 =
        "expected "
            GHC.Base.<> ( "variadic_argument"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_801 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_801) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_802 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_803 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_804 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_805 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_802
            c1_803 = TreeSitter.Node.nodeStartPoint node_801
        TreeSitter.Node.TSPoint
            r2_804
            c2_805 = TreeSitter.Node.nodeEndPoint node_801
deriving instance (GHC.Classes.Eq a_806) => GHC.Classes.Eq (VariadicArgument a_806)
deriving instance (GHC.Classes.Ord a_807) => GHC.Classes.Ord (VariadicArgument a_807)
deriving instance (GHC.Show.Show a_808) => GHC.Show.Show (VariadicArgument a_808)
instance AST.Unmarshal.Unmarshal VariadicArgument
instance Data.Foldable.Foldable VariadicArgument where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor VariadicArgument where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable VariadicArgument where
    traverse = AST.Traversable1.Class.traverseDefault1
data VariadicParameterDeclaration a = VariadicParameterDeclaration
    { ann :: a
    , name :: (GHC.Maybe.Maybe (AST.Parse.Err (Identifier a)))
    , type' :: (AST.Parse.Err (Type a))
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_809.
          AST.Traversable1.Class.Traversable1 a_809
        )
instance AST.Unmarshal.SymbolMatching VariadicParameterDeclaration where
    matchedSymbols _ = [105]
    showFailure _ node_810 =
        "expected "
            GHC.Base.<> ( "variadic_parameter_declaration"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_810 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_810) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_811 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_812 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_813 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_814 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_811
            c1_812 = TreeSitter.Node.nodeStartPoint node_810
        TreeSitter.Node.TSPoint
            r2_813
            c2_814 = TreeSitter.Node.nodeEndPoint node_810
deriving instance (GHC.Classes.Eq a_815) => GHC.Classes.Eq (VariadicParameterDeclaration a_815)
deriving instance (GHC.Classes.Ord a_816) => GHC.Classes.Ord (VariadicParameterDeclaration a_816)
deriving instance (GHC.Show.Show a_817) => GHC.Show.Show (VariadicParameterDeclaration a_817)
instance AST.Unmarshal.Unmarshal VariadicParameterDeclaration
instance Data.Foldable.Foldable VariadicParameterDeclaration where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor VariadicParameterDeclaration where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable VariadicParameterDeclaration where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousSQuoteBackslashNULSQuote = AST.Token.Token "\NUL" 0
type AnonymousBang = AST.Token.Token "!" 61
type AnonymousBangEqual = AST.Token.Token "!=" 71
type AnonymousDQuote = AST.Token.Token "\"" 79
type AnonymousPercent = AST.Token.Token "%" 65
type AnonymousPercentEqual = AST.Token.Token "%=" 32
type AnonymousAmpersand = AST.Token.Token "&" 63
type AnonymousAmpersandAmpersand = AST.Token.Token "&&" 76
type AnonymousAmpersandEqual = AST.Token.Token "&=" 35
type AnonymousAmpersandCaret = AST.Token.Token "&^" 68
type AnonymousAmpersandCaretEqual = AST.Token.Token "&^=" 36
type AnonymousLParen = AST.Token.Token "(" 8
type AnonymousRParen = AST.Token.Token ")" 9
type AnonymousStar = AST.Token.Token "*" 17
type AnonymousStarEqual = AST.Token.Token "*=" 30
type AnonymousPlus = AST.Token.Token "+" 59
type AnonymousPlusPlus = AST.Token.Token "++" 28
type AnonymousPlusEqual = AST.Token.Token "+=" 37
type AnonymousComma = AST.Token.Token "," 11
type AnonymousMinus = AST.Token.Token "-" 60
type AnonymousMinusMinus = AST.Token.Token "--" 29
type AnonymousMinusEqual = AST.Token.Token "-=" 38
type AnonymousDot = AST.Token.Token "." 6
type AnonymousDotDotDot = AST.Token.Token "..." 15
type AnonymousSlash = AST.Token.Token "/" 64
type AnonymousSlashEqual = AST.Token.Token "/=" 31
type AnonymousColon = AST.Token.Token ":" 41
type AnonymousColonEqual = AST.Token.Token ":=" 27
type AnonymousSemicolon = AST.Token.Token ";" 3
type AnonymousLAngle = AST.Token.Token "<" 72
type AnonymousLAngleMinus = AST.Token.Token "<-" 26
type AnonymousLAngleLAngle = AST.Token.Token "<<" 66
type AnonymousLAngleLAngleEqual = AST.Token.Token "<<=" 33
type AnonymousLAngleEqual = AST.Token.Token "<=" 73
type AnonymousEqual = AST.Token.Token "=" 12
type AnonymousEqualEqual = AST.Token.Token "==" 70
type AnonymousRAngle = AST.Token.Token ">" 74
type AnonymousRAngleEqual = AST.Token.Token ">=" 75
type AnonymousRAngleRAngle = AST.Token.Token ">>" 67
type AnonymousRAngleRAngleEqual = AST.Token.Token ">>=" 34
type AnonymousLBracket = AST.Token.Token "[" 18
type AnonymousRBracket = AST.Token.Token "]" 19
type AnonymousCaret = AST.Token.Token "^" 62
type AnonymousCaretEqual = AST.Token.Token "^=" 40
type AnonymousBacktick = AST.Token.Token "`" 0
data BlankIdentifier a = BlankIdentifier {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_818.
          AST.Traversable1.Class.Traversable1 a_818
        )
instance AST.Unmarshal.SymbolMatching BlankIdentifier where
    matchedSymbols _ = [7]
    showFailure _ node_819 =
        "expected "
            GHC.Base.<> ( "blank_identifier"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_819 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_819) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_820 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_821 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_822 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_823 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_820
            c1_821 = TreeSitter.Node.nodeStartPoint node_819
        TreeSitter.Node.TSPoint
            r2_822
            c2_823 = TreeSitter.Node.nodeEndPoint node_819
deriving instance (GHC.Classes.Eq a_824) => GHC.Classes.Eq (BlankIdentifier a_824)
deriving instance (GHC.Classes.Ord a_825) => GHC.Classes.Ord (BlankIdentifier a_825)
deriving instance (GHC.Show.Show a_826) => GHC.Show.Show (BlankIdentifier a_826)
instance AST.Unmarshal.Unmarshal BlankIdentifier
instance Data.Foldable.Foldable BlankIdentifier where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor BlankIdentifier where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable BlankIdentifier where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousBreak = AST.Token.Token "break" 43
type AnonymousCase = AST.Token.Token "case" 54
type AnonymousChan = AST.Token.Token "chan" 25
data Comment a = Comment {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_827.
          AST.Traversable1.Class.Traversable1 a_827
        )
instance AST.Unmarshal.SymbolMatching Comment where
    matchedSymbols _ = [89]
    showFailure _ node_828 =
        "expected "
            GHC.Base.<> ( "comment"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_828 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_828) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_829 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_830 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_831 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_832 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_829
            c1_830 = TreeSitter.Node.nodeStartPoint node_828
        TreeSitter.Node.TSPoint
            r2_831
            c2_832 = TreeSitter.Node.nodeEndPoint node_828
deriving instance (GHC.Classes.Eq a_833) => GHC.Classes.Eq (Comment a_833)
deriving instance (GHC.Classes.Ord a_834) => GHC.Classes.Ord (Comment a_834)
deriving instance (GHC.Show.Show a_835) => GHC.Show.Show (Comment a_835)
instance AST.Unmarshal.Unmarshal Comment
instance Data.Foldable.Foldable Comment where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor Comment where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable Comment where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousConst = AST.Token.Token "const" 10
type AnonymousContinue = AST.Token.Token "continue" 44
type AnonymousDefault = AST.Token.Token "default" 55
type AnonymousDefer = AST.Token.Token "defer" 48
type AnonymousElse = AST.Token.Token "else" 50
data EscapeSequence a = EscapeSequence {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_836.
          AST.Traversable1.Class.Traversable1 a_836
        )
instance AST.Unmarshal.SymbolMatching EscapeSequence where
    matchedSymbols _ = [81]
    showFailure _ node_837 =
        "expected "
            GHC.Base.<> ( "escape_sequence"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_837 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_837) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_838 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_839 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_840 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_841 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_838
            c1_839 = TreeSitter.Node.nodeStartPoint node_837
        TreeSitter.Node.TSPoint
            r2_840
            c2_841 = TreeSitter.Node.nodeEndPoint node_837
deriving instance (GHC.Classes.Eq a_842) => GHC.Classes.Eq (EscapeSequence a_842)
deriving instance (GHC.Classes.Ord a_843) => GHC.Classes.Ord (EscapeSequence a_843)
deriving instance (GHC.Show.Show a_844) => GHC.Show.Show (EscapeSequence a_844)
instance AST.Unmarshal.Unmarshal EscapeSequence
instance Data.Foldable.Foldable EscapeSequence where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor EscapeSequence where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable EscapeSequence where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousFallthrough = AST.Token.Token "fallthrough" 42
data False a = False {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_845.
          AST.Traversable1.Class.Traversable1 a_845
        )
instance AST.Unmarshal.SymbolMatching False where
    matchedSymbols _ = [88]
    showFailure _ node_846 =
        "expected "
            GHC.Base.<> ( "false"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_846 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_846) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_847 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_848 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_849 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_850 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_847
            c1_848 = TreeSitter.Node.nodeStartPoint node_846
        TreeSitter.Node.TSPoint
            r2_849
            c2_850 = TreeSitter.Node.nodeEndPoint node_846
deriving instance (GHC.Classes.Eq a_851) => GHC.Classes.Eq (False a_851)
deriving instance (GHC.Classes.Ord a_852) => GHC.Classes.Ord (False a_852)
deriving instance (GHC.Show.Show a_853) => GHC.Show.Show (False a_853)
instance AST.Unmarshal.Unmarshal False
instance Data.Foldable.Foldable False where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor False where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable False where
    traverse = AST.Traversable1.Class.traverseDefault1
data FieldIdentifier a = FieldIdentifier {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_854.
          AST.Traversable1.Class.Traversable1 a_854
        )
instance AST.Unmarshal.SymbolMatching FieldIdentifier where
    matchedSymbols _ = [196]
    showFailure _ node_855 =
        "expected "
            GHC.Base.<> ( "field_identifier"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_855 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_855) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_856 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_857 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_858 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_859 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_856
            c1_857 = TreeSitter.Node.nodeStartPoint node_855
        TreeSitter.Node.TSPoint
            r2_858
            c2_859 = TreeSitter.Node.nodeEndPoint node_855
deriving instance (GHC.Classes.Eq a_860) => GHC.Classes.Eq (FieldIdentifier a_860)
deriving instance (GHC.Classes.Ord a_861) => GHC.Classes.Ord (FieldIdentifier a_861)
deriving instance (GHC.Show.Show a_862) => GHC.Show.Show (FieldIdentifier a_862)
instance AST.Unmarshal.Unmarshal FieldIdentifier
instance Data.Foldable.Foldable FieldIdentifier where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor FieldIdentifier where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable FieldIdentifier where
    traverse = AST.Traversable1.Class.traverseDefault1
data FloatLiteral a = FloatLiteral {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_863.
          AST.Traversable1.Class.Traversable1 a_863
        )
instance AST.Unmarshal.SymbolMatching FloatLiteral where
    matchedSymbols _ = [83]
    showFailure _ node_864 =
        "expected "
            GHC.Base.<> ( "float_literal"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_864 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_864) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_865 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_866 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_867 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_868 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_865
            c1_866 = TreeSitter.Node.nodeStartPoint node_864
        TreeSitter.Node.TSPoint
            r2_867
            c2_868 = TreeSitter.Node.nodeEndPoint node_864
deriving instance (GHC.Classes.Eq a_869) => GHC.Classes.Eq (FloatLiteral a_869)
deriving instance (GHC.Classes.Ord a_870) => GHC.Classes.Ord (FloatLiteral a_870)
deriving instance (GHC.Show.Show a_871) => GHC.Show.Show (FloatLiteral a_871)
instance AST.Unmarshal.Unmarshal FloatLiteral
instance Data.Foldable.Foldable FloatLiteral where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor FloatLiteral where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable FloatLiteral where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousFor = AST.Token.Token "for" 51
type AnonymousFunc = AST.Token.Token "func" 14
type AnonymousGo = AST.Token.Token "go" 47
type AnonymousGoto = AST.Token.Token "goto" 45
data Identifier a = Identifier {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_872.
          AST.Traversable1.Class.Traversable1 a_872
        )
instance AST.Unmarshal.SymbolMatching Identifier where
    matchedSymbols _ = [1, 57, 58]
    showFailure _ node_873 =
        "expected "
            GHC.Base.<> ( "identifier, identifier, identifier"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_873 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_873) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_874 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_875 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_876 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_877 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_874
            c1_875 = TreeSitter.Node.nodeStartPoint node_873
        TreeSitter.Node.TSPoint
            r2_876
            c2_877 = TreeSitter.Node.nodeEndPoint node_873
deriving instance (GHC.Classes.Eq a_878) => GHC.Classes.Eq (Identifier a_878)
deriving instance (GHC.Classes.Ord a_879) => GHC.Classes.Ord (Identifier a_879)
deriving instance (GHC.Show.Show a_880) => GHC.Show.Show (Identifier a_880)
instance AST.Unmarshal.Unmarshal Identifier
instance Data.Foldable.Foldable Identifier where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor Identifier where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable Identifier where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousIf = AST.Token.Token "if" 49
data ImaginaryLiteral a = ImaginaryLiteral {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_881.
          AST.Traversable1.Class.Traversable1 a_881
        )
instance AST.Unmarshal.SymbolMatching ImaginaryLiteral where
    matchedSymbols _ = [84]
    showFailure _ node_882 =
        "expected "
            GHC.Base.<> ( "imaginary_literal"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_882 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_882) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_883 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_884 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_885 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_886 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_883
            c1_884 = TreeSitter.Node.nodeStartPoint node_882
        TreeSitter.Node.TSPoint
            r2_885
            c2_886 = TreeSitter.Node.nodeEndPoint node_882
deriving instance (GHC.Classes.Eq a_887) => GHC.Classes.Eq (ImaginaryLiteral a_887)
deriving instance (GHC.Classes.Ord a_888) => GHC.Classes.Ord (ImaginaryLiteral a_888)
deriving instance (GHC.Show.Show a_889) => GHC.Show.Show (ImaginaryLiteral a_889)
instance AST.Unmarshal.Unmarshal ImaginaryLiteral
instance Data.Foldable.Foldable ImaginaryLiteral where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor ImaginaryLiteral where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable ImaginaryLiteral where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousImport = AST.Token.Token "import" 5
data IntLiteral a = IntLiteral {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_890.
          AST.Traversable1.Class.Traversable1 a_890
        )
instance AST.Unmarshal.SymbolMatching IntLiteral where
    matchedSymbols _ = [82]
    showFailure _ node_891 =
        "expected "
            GHC.Base.<> ( "int_literal"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_891 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_891) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_892 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_893 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_894 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_895 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_892
            c1_893 = TreeSitter.Node.nodeStartPoint node_891
        TreeSitter.Node.TSPoint
            r2_894
            c2_895 = TreeSitter.Node.nodeEndPoint node_891
deriving instance (GHC.Classes.Eq a_896) => GHC.Classes.Eq (IntLiteral a_896)
deriving instance (GHC.Classes.Ord a_897) => GHC.Classes.Ord (IntLiteral a_897)
deriving instance (GHC.Show.Show a_898) => GHC.Show.Show (IntLiteral a_898)
instance AST.Unmarshal.Unmarshal IntLiteral
instance Data.Foldable.Foldable IntLiteral where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor IntLiteral where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable IntLiteral where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousInterface = AST.Token.Token "interface" 23
data InterpretedStringLiteralContent a = InterpretedStringLiteralContent
    { ann :: a
    , text :: Data.Text.Internal.Text
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_899.
          AST.Traversable1.Class.Traversable1 a_899
        )
instance AST.Unmarshal.SymbolMatching InterpretedStringLiteralContent where
    matchedSymbols _ = []
    showFailure _ node_900 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_900 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_900) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_901 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_902 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_903 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_904 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_901
            c1_902 = TreeSitter.Node.nodeStartPoint node_900
        TreeSitter.Node.TSPoint
            r2_903
            c2_904 = TreeSitter.Node.nodeEndPoint node_900
deriving instance (GHC.Classes.Eq a_905) => GHC.Classes.Eq (InterpretedStringLiteralContent a_905)
deriving instance (GHC.Classes.Ord a_906) => GHC.Classes.Ord (InterpretedStringLiteralContent a_906)
deriving instance (GHC.Show.Show a_907) => GHC.Show.Show (InterpretedStringLiteralContent a_907)
instance AST.Unmarshal.Unmarshal InterpretedStringLiteralContent
instance Data.Foldable.Foldable InterpretedStringLiteralContent where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor InterpretedStringLiteralContent where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable InterpretedStringLiteralContent where
    traverse = AST.Traversable1.Class.traverseDefault1
data Iota a = Iota {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_908.
          AST.Traversable1.Class.Traversable1 a_908
        )
instance AST.Unmarshal.SymbolMatching Iota where
    matchedSymbols _ = []
    showFailure _ node_909 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_909 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_909) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_910 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_911 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_912 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_913 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_910
            c1_911 = TreeSitter.Node.nodeStartPoint node_909
        TreeSitter.Node.TSPoint
            r2_912
            c2_913 = TreeSitter.Node.nodeEndPoint node_909
deriving instance (GHC.Classes.Eq a_914) => GHC.Classes.Eq (Iota a_914)
deriving instance (GHC.Classes.Ord a_915) => GHC.Classes.Ord (Iota a_915)
deriving instance (GHC.Show.Show a_916) => GHC.Show.Show (Iota a_916)
instance AST.Unmarshal.Unmarshal Iota
instance Data.Foldable.Foldable Iota where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor Iota where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable Iota where
    traverse = AST.Traversable1.Class.traverseDefault1
data LabelName a = LabelName {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_917.
          AST.Traversable1.Class.Traversable1 a_917
        )
instance AST.Unmarshal.SymbolMatching LabelName where
    matchedSymbols _ = [197]
    showFailure _ node_918 =
        "expected "
            GHC.Base.<> ( "label_name"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_918 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_918) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_919 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_920 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_921 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_922 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_919
            c1_920 = TreeSitter.Node.nodeStartPoint node_918
        TreeSitter.Node.TSPoint
            r2_921
            c2_922 = TreeSitter.Node.nodeEndPoint node_918
deriving instance (GHC.Classes.Eq a_923) => GHC.Classes.Eq (LabelName a_923)
deriving instance (GHC.Classes.Ord a_924) => GHC.Classes.Ord (LabelName a_924)
deriving instance (GHC.Show.Show a_925) => GHC.Show.Show (LabelName a_925)
instance AST.Unmarshal.Unmarshal LabelName
instance Data.Foldable.Foldable LabelName where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor LabelName where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable LabelName where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousMap = AST.Token.Token "map" 24
data Nil a = Nil {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_926.
          AST.Traversable1.Class.Traversable1 a_926
        )
instance AST.Unmarshal.SymbolMatching Nil where
    matchedSymbols _ = [86]
    showFailure _ node_927 =
        "expected "
            GHC.Base.<> ( "nil"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_927 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_927) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_928 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_929 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_930 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_931 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_928
            c1_929 = TreeSitter.Node.nodeStartPoint node_927
        TreeSitter.Node.TSPoint
            r2_930
            c2_931 = TreeSitter.Node.nodeEndPoint node_927
deriving instance (GHC.Classes.Eq a_932) => GHC.Classes.Eq (Nil a_932)
deriving instance (GHC.Classes.Ord a_933) => GHC.Classes.Ord (Nil a_933)
deriving instance (GHC.Show.Show a_934) => GHC.Show.Show (Nil a_934)
instance AST.Unmarshal.Unmarshal Nil
instance Data.Foldable.Foldable Nil where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor Nil where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable Nil where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousPackage = AST.Token.Token "package" 4
data PackageIdentifier a = PackageIdentifier {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_935.
          AST.Traversable1.Class.Traversable1 a_935
        )
instance AST.Unmarshal.SymbolMatching PackageIdentifier where
    matchedSymbols _ = [198]
    showFailure _ node_936 =
        "expected "
            GHC.Base.<> ( "package_identifier"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_936 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_936) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_937 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_938 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_939 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_940 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_937
            c1_938 = TreeSitter.Node.nodeStartPoint node_936
        TreeSitter.Node.TSPoint
            r2_939
            c2_940 = TreeSitter.Node.nodeEndPoint node_936
deriving instance (GHC.Classes.Eq a_941) => GHC.Classes.Eq (PackageIdentifier a_941)
deriving instance (GHC.Classes.Ord a_942) => GHC.Classes.Ord (PackageIdentifier a_942)
deriving instance (GHC.Show.Show a_943) => GHC.Show.Show (PackageIdentifier a_943)
instance AST.Unmarshal.Unmarshal PackageIdentifier
instance Data.Foldable.Foldable PackageIdentifier where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor PackageIdentifier where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable PackageIdentifier where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousRange = AST.Token.Token "range" 52
data RawStringLiteralContent a = RawStringLiteralContent
    { ann :: a
    , text :: Data.Text.Internal.Text
    }
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_944.
          AST.Traversable1.Class.Traversable1 a_944
        )
instance AST.Unmarshal.SymbolMatching RawStringLiteralContent where
    matchedSymbols _ = []
    showFailure _ node_945 =
        "expected "
            GHC.Base.<> ( ""
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_945 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_945) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_946 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_947 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_948 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_949 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_946
            c1_947 = TreeSitter.Node.nodeStartPoint node_945
        TreeSitter.Node.TSPoint
            r2_948
            c2_949 = TreeSitter.Node.nodeEndPoint node_945
deriving instance (GHC.Classes.Eq a_950) => GHC.Classes.Eq (RawStringLiteralContent a_950)
deriving instance (GHC.Classes.Ord a_951) => GHC.Classes.Ord (RawStringLiteralContent a_951)
deriving instance (GHC.Show.Show a_952) => GHC.Show.Show (RawStringLiteralContent a_952)
instance AST.Unmarshal.Unmarshal RawStringLiteralContent
instance Data.Foldable.Foldable RawStringLiteralContent where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor RawStringLiteralContent where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable RawStringLiteralContent where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousReturn = AST.Token.Token "return" 46
data RuneLiteral a = RuneLiteral {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_953.
          AST.Traversable1.Class.Traversable1 a_953
        )
instance AST.Unmarshal.SymbolMatching RuneLiteral where
    matchedSymbols _ = [85]
    showFailure _ node_954 =
        "expected "
            GHC.Base.<> ( "rune_literal"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_954 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_954) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_955 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_956 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_957 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_958 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_955
            c1_956 = TreeSitter.Node.nodeStartPoint node_954
        TreeSitter.Node.TSPoint
            r2_957
            c2_958 = TreeSitter.Node.nodeEndPoint node_954
deriving instance (GHC.Classes.Eq a_959) => GHC.Classes.Eq (RuneLiteral a_959)
deriving instance (GHC.Classes.Ord a_960) => GHC.Classes.Ord (RuneLiteral a_960)
deriving instance (GHC.Show.Show a_961) => GHC.Show.Show (RuneLiteral a_961)
instance AST.Unmarshal.Unmarshal RuneLiteral
instance Data.Foldable.Foldable RuneLiteral where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor RuneLiteral where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable RuneLiteral where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousSelect = AST.Token.Token "select" 56
type AnonymousStruct = AST.Token.Token "struct" 20
type AnonymousSwitch = AST.Token.Token "switch" 53
data True a = True {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_962.
          AST.Traversable1.Class.Traversable1 a_962
        )
instance AST.Unmarshal.SymbolMatching True where
    matchedSymbols _ = [87]
    showFailure _ node_963 =
        "expected "
            GHC.Base.<> ( "true"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_963 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_963) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_964 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_965 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_966 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_967 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_964
            c1_965 = TreeSitter.Node.nodeStartPoint node_963
        TreeSitter.Node.TSPoint
            r2_966
            c2_967 = TreeSitter.Node.nodeEndPoint node_963
deriving instance (GHC.Classes.Eq a_968) => GHC.Classes.Eq (True a_968)
deriving instance (GHC.Classes.Ord a_969) => GHC.Classes.Ord (True a_969)
deriving instance (GHC.Show.Show a_970) => GHC.Show.Show (True a_970)
instance AST.Unmarshal.Unmarshal True
instance Data.Foldable.Foldable True where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor True where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable True where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousType = AST.Token.Token "type" 16
data TypeIdentifier a = TypeIdentifier {ann :: a, text :: Data.Text.Internal.Text}
    deriving stock (GHC.Generics.Generic, GHC.Generics.Generic1)
    deriving anyclass
        ( forall a_971.
          AST.Traversable1.Class.Traversable1 a_971
        )
instance AST.Unmarshal.SymbolMatching TypeIdentifier where
    matchedSymbols _ = [199]
    showFailure _ node_972 =
        "expected "
            GHC.Base.<> ( "type_identifier"
                            GHC.Base.<> ( " but got "
                                            GHC.Base.<> ( if TreeSitter.Node.nodeSymbol node_972 GHC.Classes.== 65535
                                                            then "ERROR"
                                                            else Data.OldList.genericIndex debugSymbolNames (TreeSitter.Node.nodeSymbol node_972) GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r1_973 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c1_974 GHC.Base.<> ("] -" GHC.Base.<> (" [" GHC.Base.<> (GHC.Show.show r2_975 GHC.Base.<> (", " GHC.Base.<> (GHC.Show.show c2_976 GHC.Base.<> "]")))))))))
                                                        )
                                        )
                        )
      where
        TreeSitter.Node.TSPoint
            r1_973
            c1_974 = TreeSitter.Node.nodeStartPoint node_972
        TreeSitter.Node.TSPoint
            r2_975
            c2_976 = TreeSitter.Node.nodeEndPoint node_972
deriving instance (GHC.Classes.Eq a_977) => GHC.Classes.Eq (TypeIdentifier a_977)
deriving instance (GHC.Classes.Ord a_978) => GHC.Classes.Ord (TypeIdentifier a_978)
deriving instance (GHC.Show.Show a_979) => GHC.Show.Show (TypeIdentifier a_979)
instance AST.Unmarshal.Unmarshal TypeIdentifier
instance Data.Foldable.Foldable TypeIdentifier where
    foldMap = AST.Traversable1.Class.foldMapDefault1
instance GHC.Base.Functor TypeIdentifier where
    fmap = AST.Traversable1.Class.fmapDefault1
instance Data.Traversable.Traversable TypeIdentifier where
    traverse = AST.Traversable1.Class.traverseDefault1
type AnonymousVar = AST.Token.Token "var" 13
type AnonymousLBrace = AST.Token.Token "{" 21
type AnonymousPipe = AST.Token.Token "|" 69
type AnonymousPipeEqual = AST.Token.Token "|=" 39
type AnonymousPipePipe = AST.Token.Token "||" 77
type AnonymousRBrace = AST.Token.Token "}" 22
type AnonymousTilde = AST.Token.Token "~" 0

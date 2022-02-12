-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Juniper.Object.Item exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import Juniper.InputObject
import Juniper.Interface
import Juniper.Object
import Juniper.Scalar
import Juniper.ScalarCodecs
import Juniper.Union


id : SelectionSet String Juniper.Object.Item
id =
    Object.selectionForField "String" "id" [] Decode.string


title : SelectionSet String Juniper.Object.Item
title =
    Object.selectionForField "String" "title" [] Decode.string


complete : SelectionSet Bool Juniper.Object.Item
complete =
    Object.selectionForField "Bool" "complete" [] Decode.bool

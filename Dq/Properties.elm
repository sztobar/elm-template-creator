module Dq.Properties where

import Set exposing (..)
import Html exposing (Attribute)
import Html.Attributes

type alias Properties = Set String

required : Set String
required =
  Set.insert "required" writable

writable : Set String
writable =
  Set.singleton "writable"

isRequired : Properties -> Bool
isRequired props =
  Set.member "required" props

classIsRequired : Properties -> (String, Bool)
classIsRequired props =
  ("is-required", isRequired props)

attrIsRequired : Properties -> Attribute
attrIsRequired props =
  Html.Attributes.required <| isRequired props

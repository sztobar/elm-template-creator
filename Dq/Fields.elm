module Dq.Fields where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal exposing (Message)

import Dq.Properties exposing (Properties, isRequired)

viewField : String -> Properties -> Html -> Html
viewField labelText props input =
  div
    [ classList [
        ("c-field", True),
        ("is-required", isRequired props)
      ]
    ]
    [ label
      [ class "c-field__label" ]
      [ text <| labelText ++ ":"
      , input
      ]
    ]

viewInput : String -> Properties -> (String -> Message) -> String -> Html
viewInput labelText props address model =
  let
    inputAttrs =
      [ classList [
          ("c-field__input", True),
          ("is-required", isRequired props)
      ]
      , on "input" targetValue address
      , value model
      , required <| isRequired props
      ]
    inputHtml =
      input inputAttrs []
  in
    viewField labelText props inputHtml

viewCheckbox : String -> Properties -> (Bool -> Message) -> Bool -> Html
viewCheckbox labelText props address model =
  let
    checkboxAttrs =
      [ classList [
          ("c-field__checkbox", True),
          ("is-required", isRequired props)
      ]
      , type' "checkbox"
      , on "input" targetChecked address
      , checked model
      ]
    checkboxHtml =
      input checkboxAttrs []
  in
    viewField labelText props checkboxHtml

viewSelect : String -> Properties -> (Int -> Message) -> Int -> Html
viewSelect labelText props address model =
  let
    selectAttrs =
      [ classList [
          ("c-field__select", True),
          ("is-required", isRequired props)
      ]
      --, on "input" targetValue address
      --, value model
      ]
    selectHtml =
      select selectAttrs [
        option [value "1"] [text "option #1"],
        option [value "2"] [text "option #2"],
        option [value "3", selected True] [text "option #3"]
        ]
  in
    viewField labelText props selectHtml

viewMultiselect : String -> Properties -> (List Int -> Message) -> List Int -> Html
viewMultiselect labelText props address model =
  let
    selectAttrs =
      [ classList [
          ("c-field__select", True),
          ("is-required", isRequired props)
        ]
      --, on "input" targetValue address
      , multiple True
      --, checked model
      ]
    selectHtml =
      select selectAttrs [
        option [value "1", selected True] [text "option #1"],
        option [value "2"] [text "option #2"],
        option [value "3", selected True] [text "option #3"]
        ]
    --  select selectAttrs []
  in
    viewField labelText props selectHtml

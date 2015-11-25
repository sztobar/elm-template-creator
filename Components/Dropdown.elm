module Components.Dropdown where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Native.Dropdown

type alias Model =
  { options : List Option
  , opened : Bool
  , selected : Maybe ID
  , query : String
  }

type alias ID = Int

type alias Option =
  { text : Html
  , id : ID
  }


type Action 
  = UpdateQuery String
  | SelectOption ID
  | Open
  | Close

update : Action -> Model -> Model
update action model =
  case action of
    UpdateQuery query ->
      { model | query <- query }

    SelectOption id ->
      { model
        | selected <- Just id
        , opened <- False
        , query <- ""
      }

    Open ->
      { model | opened <- True }

    Close ->
      { model
        | opened <- False
        , query <- ""
      }


view address model =
  div
    [ class ("c-dropdown" ++ isOpen model) ]
    [ div
      [ class "c-dropdown__trigger"
      , onClick address Open
      ] []
    , div
      [ class ("c-dropdown__popup" ++ isOpen model) ]
      [ div
        [ class "c-dropdown__input-wrapper" ]
        [ input
          [ class "c-dropdown__input"
          , on "input" targetValue <| Signal.message address << UpdateQuery
          , Native.Dropdown.setFocus model.opened
          , onBlur address Close
          ]
          []
        ]
      , div
        [ class "c-dropdown__options" ]
        ( List.map (optionView address) model.options )
      ]  
    ]

isOpen {opened} =
  if opened == True then
     " is-open"
  else
     ""

optionView address model =
  div
    [ class "c-dropdown__option"
    , onClick address (SelectOption model.id) ]
    [ model.text ]

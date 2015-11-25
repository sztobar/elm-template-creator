module TemplateState where

import Html exposing (div, input, Html)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue, targetChecked)
import StartApp.Simple as StartApp

import Dq.Properties as Props
import Dq.Fields exposing (viewInput, viewCheckbox)

type alias Model =
  { id : Int
  , name : String
  , label : String
  , isEntryState : Bool
  , color : String 
  }

model : Model
model = 
  { id = 0
  , name = ""
  , label =  ""
  , isEntryState = False
  , color = ""
  }

getNew: Int -> Model
getNew newId =
  { model | id <- newId }

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ input
        [ disabled True
        , value (toString model.id)
        ]
        []
    , viewInput "Nazwa" Props.required (Signal.message address << UpdateName) model.name
    , viewInput "Etykieta" Props.required (Signal.message address << UpdateLabel) model.label
    , viewCheckbox "Stan wejściowy" Props.writable (Signal.message address << UpdateIsEntryState) model.isEntryState
    , viewInput "Kolor" Props.writable (Signal.message address << UpdateColor) model.color
    ]

type Action
  = New
  | UpdateName String
  | UpdateLabel String 
  | UpdateIsEntryState Bool 
  | UpdateColor String 


update: Action -> Model -> Model
update action model =
  case action of
    New ->
      model

    UpdateName name ->
      { model | name <- name }

    UpdateLabel label ->
      { model | label <- label }

    UpdateIsEntryState isEntryState ->
      { model | isEntryState <- isEntryState }

    UpdateColor color ->
      { model | color <- color }
      
main =
  StartApp.start
    { model = model
    , update = update
    , view = view
    }

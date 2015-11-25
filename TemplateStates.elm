module TemplateStates where

import TemplateState exposing (..)
import Dq.TabsList as TabsList
import Html exposing (Html, node, div)
import Html.Attributes exposing (..)
import StartApp.Simple as StartApp

type alias Model = TabsList.Model TemplateState.Model

model : Model
model = 
  { elements = []
  , nextId = 1
  , edited = Nothing
  , selectedId = Nothing
  }

type alias Action = TabsList.Action TemplateState.Action

update : Action -> Model -> Model
update action model =
  case action of
    TabsList.Add ->
      TabsList.add (TemplateState.getNew model.nextId) model

    TabsList.Update id elementAction ->
      TabsList.updateElement (id, TemplateState.update elementAction) model

    _ ->
      TabsList.update action model


view : Signal.Address Action -> Model -> Html
view address model =
  TabsList.view address model TemplateState.view

main =
  StartApp.start
    { model = model
    , update = update
    , view =
        mainView
    }

mainView action model =
 div []
     [ node "link" [ rel "stylesheet", type' "text/css", href "build/main.css" ] []
     , node "link" [ rel "stylesheet", type' "text/css", href "https://cdnjs.cloudflare.com/ajax/libs/select2/3.5.2/select2.css" ] []
     , node "script" [ type' "text/javascript", src "https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.4/jquery.js" ] []
     , node "script" [ type' "text/javascript", src "https://cdnjs.cloudflare.com/ajax/libs/select2/3.5.2/select2.js", defer True ] []
     , node "script" [ type' "text/javascript", src "select2-elm-port.js" ] []
     , view action model
     ]

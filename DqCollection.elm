module DqCollection where

import Html exposing (div, input, button, text, Html)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

type alias Model a =
    { elements : List (ID, a)
    , nextId: ID
    }

type alias ID = Int

view : Signal.Address (Action b) -> Model a -> (Signal.Address b -> a -> Html) -> Html
view address model elementView =
  let mkElementView (modelId, modelData) =
    div []
        [ button [] [ text "x" ]
        , elementView (Signal.forwardTo address (Update modelId)) modelData 
        ]
  in
    div []
      ( button
          [ onClick address Insert
          ]
          [ text "Dodaj +" ]
        :: List.map mkElementView model.elements
      )

type Action a
  = Insert
  | Update ID a
  | Remove ID


update: (ID, a -> a) -> Model a -> Model a
update (id, elementAction) model =
  let updateElement (elementId, elementModel) =
        if elementId == id
           then (elementId, elementAction elementModel)
           else (elementId, elementModel)
  in
      { model | elements <- List.map updateElement model.elements }
  
add : a -> Model a -> Model a
add element model =
  { model |
      elements <- model.elements ++ [( model.nextId, element )],
      nextId <- model.nextId + 1
  }

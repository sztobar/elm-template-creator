module TemplateStates where

import TemplateState exposing (..)
import Html exposing (div, input, button, text, Html)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import StartApp.Simple as StartApp

main =
  StartApp.start
    { model = model
    , update = update
    , view = view
    }

type alias Model =
    { elements : List (ID, TemplateState.Model)
    , nextId: ID
    }

model : Model
model = 
  { elements = []
  , nextId = 1
  }

type alias ID = Int

type Action
  = Insert TemplateState.Model
  | Modify ID TemplateState.Action
  | Remove ID

update : Action -> Model -> Model
update action model =
  case action of
    Insert emptyModel ->
      { model |
          elements <- model.elements ++ [( model.nextId, emptyModel )],
          nextId <- model.nextId + 1
      }
       
    Modify id modelAction ->
      let updateModel (modelId, model) =
            if modelId == id
               then (modelId, TemplateState.update modelAction model)
               else (modelId, model)
      in
          { model | elements <- List.map updateModel model.elements }

    Remove id ->
      { model |
          elements <- List.filter (\(modelId, _) -> modelId /= id) model.elements,
          nextId <- model.nextId
      }


view : Signal.Address Action -> Model -> Html
view address model =
  let elementView (modelId, modelData) =
    TemplateState.view (Signal.forwardTo address (Modify modelId)) modelData
  in
    div []
      ( button
          [ onClick address (Insert TemplateState.model)
          ]
          [ text "Dodaj +" ]
        :: List.map elementView model.elements
      )

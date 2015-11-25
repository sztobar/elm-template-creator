module Dq.TabsList where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (object2, (:=), Decoder)
import KeyCodes

import Debug exposing (log)

type alias Model a =
  { elements : List (ID, a)
  , nextId : ID
  , edited : Maybe (ID, String)
  , selectedId : Maybe ID
  }

type alias Named a =
  { a | name : String }

type alias ID = Int

type Action a
  = UpdateName ID String
  | Update ID a
  | StartEdit ID String
  | AbortEdit
  | KeyDownEdit ID Int
  | Add
  | Select ID
  | Remove

view : Signal.Address (Action b) -> Model (Named a) -> (Signal.Address b -> (Named a) -> Html) -> Html
view address model elementView =
  let tabsView = getTabsView address model
  in
    div [ class "c-tabs" ]
        [ div
            [ class "c-tabs__list" ]
            ( tabsView ++ [ addViewTabLabel address ] )
        , div
            [ class "c-tabs__content" ]
            [ viewTabContent address model elementView ]
        ]

getTabsView : Signal.Address (Action b) -> Model (Named a) -> List Html
getTabsView address model =
  case model.edited of
    Nothing ->
      List.map (viewTab address model.selectedId) model.elements

    Just (id, content) ->
      List.map (viewMaybeEditedTab address model.selectedId (id, content)) model.elements

viewMaybeEditedTab : Signal.Address (Action b) -> Maybe ID -> (ID, String) -> (ID, Named a) -> Html
viewMaybeEditedTab address selected (id, content) (modelId, modelElement) =
  if modelId == id then
    viewEditedTab address selected (id, content)
  else
    viewTab address selected (modelId, modelElement)

addViewTabLabel : Signal.Address (Action a) -> Html
addViewTabLabel address =
  div [ class "c-tabs__add-tab"
      , onClick address Add
      ]
      [ text "Dodaj +" ]

viewTab : Signal.Address (Action b) -> Maybe ID -> (ID, Named a) -> Html
viewTab address selected (id, {name}) =
  div [ class ("c-tabs__tab" ++ isActive selected id) ]
      [ input
        [ readonly True
        , onDoubleClick address (StartEdit id name)
        , onClick address (Select id)
        , value name
        , class "c-tabs__input"
        ]
        []
      , button
        [ class "c-tabs__remove-tab" ]
        [ text "x" ]
      ]

isActive : Maybe ID -> ID -> String
isActive edited id = 
    case edited of
      Nothing -> ""
      Just editedId -> if editedId == id then " is-active" else ""

viewEditedTab : Signal.Address (Action b) -> Maybe ID -> (ID, String) -> Html
viewEditedTab address selected (id, content) =
  div [ class ("c-tabs__tab is-edited" ++ isActive selected id) ]
      [ input
        [ readonly False
        , onClick address (Select id)
        , on "input" targetValue (Signal.message address << (UpdateName id))
        , onKeyDown address (KeyDownEdit id)
        , value content
        , class "c-tabs__input"
        ]
        []
      , button
        [ class "c-tabs__remove-tab" ]
        [ text "Y" ]
      ]

viewTabContent : Signal.Address (Action b) -> Model a -> (Signal.Address b -> a -> Html) -> Html
viewTabContent address model modelView =
  case model.selectedId of
    Nothing ->
      viewEmptyContent

    Just id ->
      let selectedModel = getModel id model.elements
      in
         case selectedModel of
           Nothing ->
             viewEmptyContent

           Just (modelId, modelItem) ->
             modelView (Signal.forwardTo address (Update id)) modelItem


getModel : ID -> List (ID, a) -> Maybe (ID, a)
getModel id models =
  let filteredList = List.filter (\(itemId, item) -> itemId == id) models
  in
     List.head filteredList

viewEmptyContent : Html
viewEmptyContent =
  div []
      []

add : a -> Model a -> Model a
add element model =
  { model |
      elements <- model.elements ++ [( model.nextId, element )],
      nextId <- model.nextId + 1,
      selectedId <- Just model.nextId
  }

select : ID -> Model a -> Model a
select id model =
  { model | selectedId <- Just id }


updateElement : (ID, a -> a) -> Model a -> Model a
updateElement (id, modelAction) model =
  let updateElement (elementId, elementModel) =
        if elementId == id
           then (elementId, modelAction elementModel)
           else (elementId, elementModel)
  in
     { model | elements <- List.map updateElement model.elements }

update: Action b -> Model (Named a) -> Model (Named a)
update action model =
  case action of
    Select id ->
      { model | selectedId <- Just id }

    UpdateName id content ->
      { model | edited <- Just (id, content) }

    KeyDownEdit id keyCode ->
      if | keyCode == KeyCodes.enter -> endEdit id model
         | keyCode == KeyCodes.escape -> abortEdit model
         | otherwise -> model

    StartEdit id content ->
      { model | edited <- Just (id, content) }

    AbortEdit ->
      abortEdit model

    _ ->
      model

abortEdit : Model (Named a) -> Model (Named a)
abortEdit model =
  { model | edited <- Nothing }

updateName : String -> Named a -> Named a
updateName name model =
  { model | name <- name }

endEdit : ID -> Model (Named a) -> Model (Named a)
endEdit id model =
  case model.edited of
    Nothing ->
      model

    Just (id, content) ->
      let endEditModel = { model | edited <- Nothing }
      in
        updateElement (id, updateName content) endEditModel
    

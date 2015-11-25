module Template.Action where

import StartApp.Simple as StartApp

import TemplateStates as States
import Html exposing (..)
import Html.Attributes exposing (..)
import Dq.Properties as Props
import Dq.Fields exposing (viewInput, viewCheckbox, viewSelect, viewMultiselect)

type alias Model =
  { id : Int
  , name : String
  , label : String
  , permissionLabel: String
  , statesFrom : List Int
  , stateTo : Int
  , actionProperties : ActionProperties
  }

type alias ActionProperties =
  { lockBefore : Bool
  , unlockAfter : Bool
  , read : Bool
  , shared : Bool
  }

init : Model
init =
  { id = 0
  , name = ""
  , label = ""
  , permissionLabel = ""
  , statesFrom = []
  , stateTo = -1
  , actionProperties =
    { lockBefore = False
    , unlockAfter = False
    , read = False
    , shared = False
    }
  }

type alias Source = 
  { states : States.Model
  }
      
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
    , viewInput "Etykieta uprawnień" Props.writable (Signal.message address << UpdatePermissionLabel) model.permissionLabel
    , viewMultiselect "Stany z" Props.required (Signal.message address << UpdateStatesFrom) model.statesFrom
    , viewSelect "Stan do" Props.required (Signal.message address << UpdateStateTo) model.stateTo
    ]

type Action
  = New
  | UpdateName String
  | UpdateLabel String 
  | UpdatePermissionLabel String 
  | UpdateStatesFrom (List Int)
  | UpdateStateTo Int
  | UpdateLockBefore Bool
  | UpdateUnlockAfter Bool
  | UpdateRead Bool
  | UpdateShared Bool


update: Action -> Model -> Model
update action model =
  case action of
    New ->
      model

    UpdateName name ->
      { model | name <- name }

    UpdateLabel label ->
      { model | label <- label }

    UpdatePermissionLabel label ->
      { model | permissionLabel <- label }

    UpdateStatesFrom statesFrom ->
      { model | statesFrom <- statesFrom }

    UpdateStateTo stateTo ->
      { model | stateTo <- stateTo }

    --UpdateLockBefore lockBefore ->
    --  { model | lockBefore <- lockBefore }

    --UpdateUnlockAfter unlockAfter ->
    --  { model | unlockAfter <- unlockAfter }
    --  
    --UpdateRead read ->
    --  { model | read <- read }

    --UpdateShared shared ->
    --  { model | shared <- shared }
      
main =
  StartApp.start
    { model = init
    , update = update
    , view = view
    }

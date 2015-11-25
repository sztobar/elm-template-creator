module TemplateCreator where

import TemplateStates

type alias Model =
  { states : TemplateStates.Model
  , actions: TemplateActions.Model
  , properties: TemplateProperties.Model
  , fields: TemplateFields.Model
  , selectedTab: Int
  }

update action model =
  case action of
    States stateAction ->
      { model |
          states <- TemplateStates.update stateAction model.states
      }

view address model =
  TemplateStates.view (Signal.forwardTo address States) model.states


{--
view address model =
  tabs (Signal.forwardTo address SelectTab) model.selectedTab
    [ "właściwości" TemplateProperties.view (Signal.forwardTo address Properties) model.properties
    , "stany" TemplateStates.view (Signal.forwardTo address States) model.states
    , "akcje" TemplateActions.view (Signal.forwardTo address Actions) model.actions
    , "pola" TemplateFields.view (Signal.forwardTo address Fields) model.fields
    ]
    --}

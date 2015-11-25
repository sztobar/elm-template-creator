import Html exposing (div, input, Html)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue, targetChecked)
import StartApp.Simple as StartApp


main =
  startapp.start
    { model = model
    , update = update
    , view = view
    }

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


view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ input
        [ disabled True
        , value (toString model.id)
        ]
        []
    , input
        [ placeholder "name"
        , value model.name
        , on "input" targetValue (Signal.message address << UpdateName)
        ]
        []
    , input
        [ placeholder "label"
        , value model.label
        , on "input" targetValue (Signal.message address << UpdateLabel)
        ]
        []
    , input
        [ type' "checkbox"
        , checked model.isEntryState
        , on "input" targetChecked (Signal.message address << UpdateIsEntryState)
        ]
        []
    , input
        [ placeholder "color"
        , value model.color
        , on "input" targetValue (Signal.message address << UpdateColor)
        ]
        []
    ]


type Action
  = UpdateName String
  | UpdateLabel String 
  | UpdateIsEntryState Bool 
  | UpdateColor String 


update: Action -> Model -> Model
update action model =
  case action of
    UpdateName name ->
      { model | name <- name }

    UpdateLabel label ->
      { model | label <- label }

    UpdateIsEntryState isEntryState ->
      { model | isEntryState <- isEntryState }

    UpdateColor color ->
      { model | color <- color }
      

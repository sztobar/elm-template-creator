--import TemplateStates exposing (..)
import Template.Action exposing (init, update, view)
import StartApp.Simple as StartApp
import Html exposing (node, div)
import Html.Attributes exposing (..)

main =
  StartApp.start
    { model = init
    , update = update
    , view = 
      mainView
    }
mainView action model =
 div []
     [ node "link" [ rel "stylesheet", type' "text/css", href "build/main.css" ] []
     , view action model
     ]

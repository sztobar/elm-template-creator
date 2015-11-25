import Components.Dropdown as Dropdown
import StartApp.Simple as StartApp
import Html exposing (text, div, node)
import Html.Attributes exposing (rel, type', href, class)

main =
  StartApp.start
    { view = view
    , model = init
    , update = Dropdown.update
    }


init =
  { opened = False
  , selected = Nothing
  , query = ""
  , options =
    [ { text = text "option #1"
      , id = 1
      }
    , { text = text "odd thing #2"
      , id = 2
      }
    , { text = text "not an important text #3"
      , id = 3
      }
    ]
  }

view action model =
 div []
     [ node "link" [ rel "stylesheet", type' "text/css", href "../build/main.css" ] []
     , Dropdown.view action model
     ]
 

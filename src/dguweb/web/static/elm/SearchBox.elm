
module SearchBox exposing (..)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (..)
import Task
import String


main: Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

-- MODEL

type alias Dataset =
  { title: String
  , publisher_title: String
  , name: String
  }


type alias Model = List Dataset


init : (Model, Cmd Msg)
init =
  ([], Cmd.none)


-- UPDATE


type Msg
  = Lookup String
  | FetchSucceed Model
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Lookup q ->
      (model, if String.length q > 2 then getMatchingDatasets q else Cmd.none)

    FetchSucceed resultList ->
      (resultList, Cmd.none)

    FetchFail error ->
      (model, Cmd.none)


getMatchingDatasets: String -> Cmd Msg
getMatchingDatasets query =
  let
    url = "/search?_format=json&q=" ++ query
  in
    Task.perform
      FetchFail
      FetchSucceed
      (Http.get searchApiDecoder url)


searchApiDecoder: Decoder Model
searchApiDecoder =
  Json.Decode.list
    (object3 Dataset
      ("title" := Json.Decode.string)
      ("publisher_title" := Json.Decode.string)
      ("name" := Json.Decode.string)
    )


-- VIEW


viewCompletionItem : Dataset -> Html Msg
viewCompletionItem result =
  Html.li []
    [ Html.a [ href ("/dataset/" ++ result.name) ]
        [ Html.text (result.title ++ " - " ++ result.publisher_title) ]
    ]


viewCompletionMenu : Model -> Html Msg
viewCompletionMenu results =
  Html.div [ class "autocomplete-menu" ]
    [ Html.div [ class "autocomplete-inner" ]
      [ Html.ul []
        (List.map viewCompletionItem results)
      ]
    ]


viewForm : Html Msg
viewForm =
  Html.form
    [ action "/search"
    , method "GET"
    ]
    [ Html.fieldset []
      [ Html.input
        [ id "q"
        , name "q"
        , type' "text"
        , placeholder "Search for data"
        , class "form-control search"
        , autocomplete False
        , onInput Lookup
        ]
        []
      ]
    ]


view : Model -> Html Msg
view model =
  Html.div []
    (if (List.length model > 0) then
      [ viewForm
      , viewCompletionMenu model
      ]
    else
      [ viewForm ]
    )

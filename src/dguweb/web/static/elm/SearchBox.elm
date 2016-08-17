port module SearchBox exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (..)
import Task
import String


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- PORTS


port hitReturn : String -> Cmd msg



-- MODEL


type alias Dataset =
    { title : String
    , publisher_title : String
    , name : String
    }


type alias Model =
    { datasets : List Dataset
    , selectedIndex : Int
    , visible : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] -1 False, Cmd.none )



-- UPDATE


type Msg
    = Lookup String
    | FetchSucceed (List Dataset)
    | FetchFail Http.Error
    | SelectPrevious
    | SelectNext
    | CloseCompletions
    | GoToSelection


newIndexModel : Model -> Int -> Model
newIndexModel model inc =
    let
        try =
            model.selectedIndex + inc
    in
        if try < 0 || try >= (List.length model.datasets) then
            model
        else
            { model | selectedIndex = try }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Lookup q ->
            ( { model | visible = True }
            , if String.length q > 2 then
                getMatchingDatasets q
              else
                Cmd.none
            )

        FetchSucceed resultList ->
            ( { model | datasets = resultList }, Cmd.none )

        FetchFail error ->
            ( model, Cmd.none )

        SelectPrevious ->
            ( newIndexModel model -1, Cmd.none )

        SelectNext ->
            ( newIndexModel model 1, Cmd.none )

        CloseCompletions ->
            ( { model | visible = False }, Cmd.none )

        GoToSelection ->
            ( model, hitReturn ".selected a" )


getMatchingDatasets : String -> Cmd Msg
getMatchingDatasets query =
    let
        url =
            "/search?_format=json&q=" ++ query
    in
        Task.perform
            FetchFail
            FetchSucceed
            (Http.get searchApiDecoder url)


searchApiDecoder : Decoder (List Dataset)
searchApiDecoder =
    Json.Decode.list
        (object3 Dataset
            ("title" := Json.Decode.string)
            ("publisher_title" := Json.Decode.string)
            ("name" := Json.Decode.string)
        )



-- VIEW


viewCompletionItem : Int -> Int -> Dataset -> Html Msg
viewCompletionItem liIdx selectedIdx result =
    Html.li
        [ class
            (if liIdx == selectedIdx then
                "selected"
             else
                ""
            )
        ]
        [ Html.a [ href ("/dataset/" ++ result.name) ]
            [ Html.text (result.title ++ " - " ++ result.publisher_title) ]
        ]


viewCompletionMenu : Model -> Html Msg
viewCompletionMenu model =
    Html.div [ class "autocomplete-menu" ]
        [ Html.div [ class "autocomplete-inner" ]
            [ Html.ul []
                (List.indexedMap
                    (viewCompletionItem model.selectedIndex)
                    model.datasets
                )
            ]
        ]


viewForm : Html Msg
viewForm =
    let
        keydownOptions =
            { preventDefault = True, stopPropagation = False }

        keydownDecoder =
            (Json.Decode.customDecoder keyCode
                (\code ->
                    if code == 38 then
                        Ok SelectPrevious
                    else if code == 40 then
                        Ok SelectNext
                    else if code == 27 then
                        Ok CloseCompletions
                    else if code == 13 then
                        Ok GoToSelection
                    else
                        Err "not handling that key"
                )
            )
    in
        Html.input
            [ id "q"
            , name "q"
            , type' "text"
            , placeholder "Search for data"
            , class "form-control search"
            , autocomplete False
            , onInput Lookup
            , onWithOptions "keydown" keydownOptions keydownDecoder
            ]
            []


view : Model -> Html Msg
view model =
    Html.div []
        (if model.visible && List.length model.datasets > 0 then
            [ viewForm
            , viewCompletionMenu model
            ]
         else
            [ viewForm ]
        )

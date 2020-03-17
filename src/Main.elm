module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Html exposing (Html, div, h1, img, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (src, style)



---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "OData client"
    , body =
        [ layout [] <|
            column [ width fill, spacingXY 0 0 ]
                [ navBar
                , row [ height (px 600), width fill ]
                    [ leftPane
                    , el [ centerX ] <| dataTable
                    , rightPane
                    ]
                ]
        ]
    }


borderColour : Color
borderColour =
    rgb255 80 80 80


bggray : Color
bggray =
    rgb255 230 230 230


navBar : Element Msg
navBar =
    row
        [ width fill
        , paddingXY 30 4
        , Border.widthEach { bottom = 2, top = 0, left = 0, right = 0 }
        , Border.color borderColour
        , Background.color bggray
        ]
        [ el [ centerX ] <| Element.text "OData client"
        ]


leftPane : Element Msg
leftPane =
    column
        [ height fill
        , paddingXY 30 4
        , Border.widthEach { bottom = 0, top = 0, left = 0, right = 2 }
        , Background.color bggray
        ]
        [ el [] <| Element.text "Left pane placeholder!"
        ]


rightPane : Element Msg
rightPane =
    column
        [ height fill
        , paddingXY 30 4
        , Border.widthEach { bottom = 0, top = 0, left = 2, right = 0 }
        , Background.color bggray
        ]
        [ el [] <| Element.text "Right pane placeholder!"
        ]


dataTable : Element Msg
dataTable =
    html <|
        Html.table
            [ style "border" "1px solid black"
              , style "border-collapse" "collapse"
            ]
            [ thead [ style "background-color" "darkgrey" ]
                [ tr []
                    [ th [ style "border" "1px solid black" ] [ Html.text "Column heading!" ]
                    , th [ style "border" "1px solid black" ] [ Html.text "Column heading 2" ]
                    ]
                ]
            , tbody []
                [ tr []
                    [ td [ style "border" "1px solid black" ] [ Html.text "Cell 1" ]
                    , td [ style "border" "1px solid black" ] [ Html.text "Cell 2" ]
                    ]
                ]
            ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.document
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

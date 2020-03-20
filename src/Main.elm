module Main exposing (..)

import Browser
import Debug exposing (todo)
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
            column [ width fill, height fill, spacingXY 0 0 ]
                [ navBar
                , row [ height fill, width fill ]
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



{- I need to use HTML here because I need to do more than elm-ui's datatable allows. -}


packed : List (Attribute msg)
packed =
    [ spacing 0, padding 0, Element.explain Debug.todo ]


dataTable : Element Msg
dataTable =
    column
        packed
        [ dataTableFilter
        , row packed
            [ dataTableContents
            , dataTableScrollbar
            ]
        ]


dataTableFilter : Element Msg
dataTableFilter =
    el [ width fill, height (px 20), Background.color bggray ] (Element.text "filter")


dataTableContents : Element Msg
dataTableContents =
    html <|
        Html.table
            [ style "border" "1px solid grey"
            , style "border-collapse" "collapse"
            ]
            [ thead [ style "background-color" "darkgrey" ]
                [ tr []
                    [ th [ style "border" "1px solid black" ] [ Html.text "Column A" ]
                    , th [ style "border" "1px solid black" ] [ Html.text "Column B" ]
                    ]
                ]
            , tbody []
                [ tr []
                    [ td [ style "border" "1px solid black" ] [ Html.text "Cell A1" ]
                    , td [ style "border" "1px solid black" ] [ Html.text "Cell B1" ]
                    ]
                , tr []
                    [ td [ style "border" "1px solid black" ] [ Html.text "Cell A2" ]
                    , td [ style "border" "1px solid black" ] [ Html.text "Cell B2" ]
                    ]
                , tr []
                    [ td [ style "border" "1px solid black" ] [ Html.text "Cell A2" ]
                    , td [ style "border" "1px solid black" ] [ Html.text "Cell B2" ]
                    ]
                , tr []
                    [ td [ style "border" "1px solid black" ] [ Html.text "Cell A2" ]
                    , td [ style "border" "1px solid black" ] [ Html.text "Cell B2" ]
                    ]
                , tr []
                    [ td [ style "border" "1px solid black" ] [ Html.text "Cell A2" ]
                    , td [ style "border" "1px solid black" ] [ Html.text "Cell B2" ]
                    ]
                , tr []
                    [ td [ style "border" "1px solid black" ] [ Html.text "Cell A2" ]
                    , td [ style "border" "1px solid black" ] [ Html.text "Cell B2" ]
                    ]
                , tr []
                    [ td [ style "border" "1px solid black" ] [ Html.text "Cell A2" ]
                    , td [ style "border" "1px solid black" ] [ Html.text "Cell B2" ]
                    ]
                , tr []
                    [ td [ style "border" "1px solid black" ] [ Html.text "Cell A2" ]
                    , td [ style "border" "1px solid black" ] [ Html.text "Cell B2" ]
                    ]
                ]
            ]

scrollbarColour : Color
scrollbarColour =
    rgb255 80 80 80

dataTableScrollbar : Element Msg
dataTableScrollbar =
    column [height fill, width (px 20)] 
    [
        el [ height (px 50) ] none
        , el [ height (px 50), width fill, Background.color scrollbarColour ] (Element.text " ")
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

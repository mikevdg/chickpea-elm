module Main exposing (..)

import Browser
import Debug exposing (todo)
import Element as El
import Element.Background as Background
import Element.Border as Border
import Html exposing (..)
import Html.Attributes exposing (placeholder, src, style)
import Html.Events exposing (..)
import Http
import Xml.Decode exposing (..)



---- Progress markers ----


todoSpinner = 
    Debug.todo "Make a spinner when it's loading data. "

todoReadSchema =
    Debug.todo "Read the OData schema."


todoReadTable =
    Debug.todo "Read the OData table data"


todoScrollBar =
    Debug.todo "Make the scrollbar scroll"


todoSearchBar =
    Debug.todo "Search bar functionality."


todoColumnSort =
    Debug.todo "Click column headings to sort them."


todoColumnRearrange =
    Debug.todo "Drag and drop headings to rearrange columns."


todoHideColumn =
    Debug.todo "Context menu to hide and show columns"


todoEditTable =
    Debug.todo "Edit cells"



---- Model ----


type Model
    = Failure
    | Loading
    | Success (List String)


init : ( Model, Cmd Msg )
init =
    ( Loading, getMetadata )



---- Update ----


type Msg
    = MorePlease
    | GotMetadata (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( Loading, getMetadata )

        GotMetadata result ->
            case result of
                Ok xml ->
                    ( Success (parseXml xml), Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


getMetadata : Cmd Msg
getMetadata =
    Http.get
        { url = "https://services.odata.org/TripPinRESTierService/(S(mly0lemodbb4rmdukjup4lcm))/$metadata"
        , expect = Http.expectString GotMetadata
        }


metadataDecoder : Decoder (List String)
metadataDecoder =
    path [ "edmx:DataServices", "Schema", "EntityContainer", "EntitySet" ]
        (Xml.Decode.list
            (stringAttr "Name")
        )


parseXml : String -> List String
parseXml xmlString =
    Result.withDefault [ "error" ] (Xml.Decode.decodeString metadataDecoder xmlString)



---- View ----


view : Model -> Browser.Document Msg
view model =
    { title = "OData client"
    , body =
        [ El.layout [] <|
            El.column [ El.width El.fill, El.height El.fill, El.spacingXY 0 0 ]
                [ navBar
                , El.row [ El.height El.fill, El.width El.fill ]
                    [ leftPane model                        
                        , El.el [ El.centerX ] <| El.html <| dataTable model
                    , rightPane
                    ]
                ]
        ]
    }


borderColour : El.Color
borderColour =
    El.rgb255 80 80 80


bggray : El.Color
bggray =
    El.rgb255 230 230 230


navBar : El.Element Msg
navBar =
    El.row
        [ El.width El.fill
        , El.paddingXY 30 4
        , Border.widthEach { bottom = 2, top = 0, left = 0, right = 0 }
        , Border.color borderColour
        , Background.color bggray
        ]
        [ El.el [ El.centerX ] <| El.text "OData client"
        ]


leftPane : Model -> El.Element Msg
leftPane model =
    El.column
        [ El.height El.fill
        , El.paddingXY 30 4
        , Border.widthEach { bottom = 0, top = 0, left = 0, right = 2 }
        , Background.color bggray
        ]
        [ El.el [] <| El.html <| viewEntities model   
        ]


rightPane : El.Element Msg
rightPane =
    El.column
        [ El.height El.fill
        , El.paddingXY 30 4
        , Border.widthEach { bottom = 0, top = 0, left = 2, right = 0 }
        , Background.color bggray
        ]
        [ El.el [] <| El.text "Right pane placeholder!"
        ]



{- I need to use HTML here because I need to do more than elm-ui's datatable allows. -}


dataTable : Model -> Html Msg
dataTable model =
    Html.div
        []
        [ filterDiv
        , Html.div
            [ style "display" "grid"
            , style "height" "300px"
            , style "width" "300px"
            ]
            [ scrollDiv
            , contentsDiv
            ]
        ]


todoMarginTop =
    Debug.todo "Need DOM access for margin-top and margin-bottom here (and margin-right later). Otherwise it isn't aligned."


scrollDiv : Html Msg
scrollDiv =
    Html.div
        [ style "overflow-y" "scroll"
        , style "grid-column" "1"
        , style "grid-row" "1"
        , style "z-index" "2"
        , style "pointer-events" "none"
        , style "margin-top" "47px"
        , style "margin-bottom" "12px"
        ]
        [ Html.div
            [ style "height" "10000px"
            , style "width" "100%"
            ]
            []
        ]


contentsDiv : Html Msg
contentsDiv =
    Html.div
        [ style "overflow-x" "auto"

        --, style "overflow-y" ""
        , style "grid-column" "1"
        , style "grid-row" "1"
        , style "z-index" "1"
        , style "margin-right" "12px"
        ]
        [ dataTableContents
        ]


filterDiv : Html Msg
filterDiv =
    Html.div [ style "background" "gray" ]
        [ Html.input [ Html.Attributes.placeholder "Search..." ] [] ]


cellStyle : Html.Attribute msg
cellStyle =
    style "border" "1px solid gray"


exampleData : Html msg
exampleData =
    tr []
        [ td [ cellStyle ] [ Html.text "Cell A2" ]
        , td [ cellStyle ] [ Html.text "Cell B1" ]
        , td [ cellStyle ] [ Html.text "Cell B2" ]
        ]


dataTableContents : Html Msg
dataTableContents =
    Html.table
        [ style "border" "1px solid grey"
        , style "border-collapse" "collapse"
        ]
        [ thead [ style "background-color" "darkgrey" ]
            [ tr []
                [ th
                    [ cellStyle
                    , Html.Attributes.rowspan 2
                    ]
                    [ Html.text "Column A" ]
                , th
                    [ cellStyle
                    , Html.Attributes.colspan 2
                    ]
                    [ Html.text "Column B" ]
                ]
            , tr []
                [ th [ cellStyle ]
                    [ Html.text "Column B1" ]
                , th [ cellStyle ]
                    [ Html.text "Column B2" ]
                ]
            ]
        , tbody []
            [ exampleData
            , exampleData
            , exampleData
            , exampleData
            , exampleData
            , exampleData
            , exampleData
            , exampleData
            ]
        ]


viewEntities : Model -> Html Msg
viewEntities model =
    case model of
        Failure ->
            div []
                [ text "Failed to load. "
                , button [ onClick MorePlease ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success entityList ->
            div []
                [ button [ onClick MorePlease, style "display" "block" ] [ text "Reload!" ]
                , viewEntityList entityList
                ]


viewEntityList : List String -> Html Msg
viewEntityList entityList =
    ul [] (List.map (\it -> li [] [ text it ]) entityList)


main : Program () Model Msg
main =
    Browser.document
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

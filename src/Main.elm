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
import Json.Decode exposing (..)



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


type alias Model =
    { schema : Loadable Schema
    , currentTable : TableModel
    }


type Loadable a
    = Failure String
    | Loading
    | Loaded a



{- I am a model for the on-page table -}


type alias TableModel =
    { baseUrl : String
    , query : Query
    , tableData : Loadable TableData

    --    , schema : Schema
    --  , edits : Edits
    }


initTableModel : TableModel
initTableModel =
    { baseUrl = ""
    , query = initQuery
    , tableData = Loading
    }



{- I am the "filter" and the "columns" of an on-page table. -}


type alias Query =
    { scrollSkip : Int
    , scrollTop : Int
    , visibleColumns : List ColumnDefinition

    --    , filter : Filter
    }


initQuery : Query
initQuery =
    { scrollSkip = 100
    , scrollTop = 0
    , visibleColumns = []
    }



{- I am the cell values of an on-page table. -}


type alias TableData =
    { rows : List CellValue }

{- I am one of the cells in a table. -}


type alias CellValue =
    String


type alias ColumnDefinition =
    { heading : String

    -- , type : ColumnType
    }


type alias Schema =
    { endpoints : List String
    }


initSchema : Schema
initSchema =
    { endpoints = []
    }


init : ( Model, Cmd Msg )
init =
    ( { schema = Loading
      , currentTable = initTableModel
      }
    , getMetadata
    )



---- Update ----


type Msg
    = RefreshSchema
    | GotMetadata (Result Http.Error String)
    | GotTableContents (Result Http.Error String)
    | ChooseTable String


chooseTable : String -> Model -> Model
chooseTable name model =
    { schema = model.schema
    , currentTable =
        { baseUrl = name
        , query = model.currentTable.query
        , tableData = Loading
        }
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RefreshSchema ->
            ( { model | schema = Loading }, getMetadata )

        GotMetadata result ->
            case result of
                Ok xml ->
                    ( { model | schema = parseSchemaXml xml }, Cmd.none )

                Err error ->
                    ( { model | schema = Failure (httpError error) }, Cmd.none )

        GotTableContents result ->
            case result of 
            Ok json ->
                    (model, Cmd.none)
                    {-( { model | schema = parseTableContents json }, Cmd.none )-}

            Err error ->
                    ( { model | schema = Failure (httpError error) }, Cmd.none )


        ChooseTable entityName ->
            ( chooseTable entityName model, refreshTable entityName )


httpError : Http.Error -> String
httpError httpE =
    case httpE of
        Http.BadUrl string ->
            "BadURL: " ++ string

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus status ->
            "Bad status: " ++ String.fromInt status

        Http.BadBody body ->
            "Bad body: " ++ body


getMetadata : Cmd Msg
getMetadata =
    Http.get
        { url = "https://services.odata.org/TripPinRESTierService/(S(mly0lemodbb4rmdukjup4lcm))/$metadata"
        , expect = Http.expectString GotMetadata
        }


refreshTable :
    String
    -> Cmd Msg -- Needs a Query.
refreshTable tableName =
    Http.get
        { url = "https://services.odata.org/TripPinRESTierService/(S(mly0lemodbb4rmdukjup4lcm))/" ++ tableName ++ "?$format=json"
        , expect = Http.expectString GotMetadata
        }


metadataDecoder : Xml.Decode.Decoder Schema
metadataDecoder =
    Xml.Decode.map Schema
        (path [ "edmx:DataServices", "Schema", "EntityContainer", "EntitySet" ]
            (Xml.Decode.list
                (stringAttr "Name")
            )
        )


parseSchemaXml : String -> Loadable Schema
parseSchemaXml xmlString =
    let
        r =
            Xml.Decode.decodeString metadataDecoder xmlString
    in
    case r of
        Ok value ->
            Loaded value

        Err error ->
            Failure error

{-
parseTableContents json = 
      let
        r =
            Json.Decode.decodeString tableContentsDecoder json
    in
    case r of
        Ok value ->
            Loaded value

        Err error ->
            Failure error

tableContentsDecoder : Json.Decode.Decoder todo

tableContentsDecoder = Debug.todo
-}

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
    case model.schema of
        Failure error ->
            div []
                [ text ("Failed to load: " ++ error)
                , button [ onClick RefreshSchema ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Loaded data ->
            div []
                [ button [ onClick RefreshSchema, style "display" "block" ] [ text "Reload!" ]
                , viewEntityList data.endpoints
                ]


viewEntityList : List String -> Html Msg
viewEntityList entityList =
    ul []
        (List.map
            (\it ->
                li
                    [ onClick (ChooseTable it)
                    , style "cursor" "pointer"
                    ]
                    [ text it ]
            )
            entityList
        )


main : Program () Model Msg
main =
    Browser.document
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

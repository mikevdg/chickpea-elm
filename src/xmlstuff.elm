module Main exposing (..)

--import Json.Decode exposing (Decoder, field, string)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Xml.Decode exposing (..)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Model
    = Failure
    | Loading
    | Success (List String)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getMetadata )


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

parseXml : String -> (List String)
parseXml xmlString =
    Result.withDefault ["error"] (Xml.Decode.decodeString metadataDecoder xmlString)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Metadata" ]
        , viewEntities model
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

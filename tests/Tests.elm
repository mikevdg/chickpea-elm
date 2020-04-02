module Tests exposing (..)

import Test exposing (..)
import Expect
import Schema exposing (schemaDecoder)
import Xml.Decode exposing (decodeString)
import MetadataXML exposing (metadata)

parseXmlMetadata : Test
parseXmlMetadata =
    describe "Parsing $metadata"
        [ test "Parsing" <|
            \_ ->
                Expect.ok <| decodeString schemaDecoder metadata
        ]


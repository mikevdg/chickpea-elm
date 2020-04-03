module Tests exposing (parseSimpleJson)

import Expect
import MetadataXML exposing (metadata)
import DataTable exposing (EdmString)
import Schema exposing (schemaDecoder)
import Test exposing (test, Test, describe)
import Xml.Decode exposing (decodeString)
import Dict exposing (fromList)


parseXmlMetadata : Test
parseXmlMetadata =
    describe "Parsing $metadata"
        [ test "Parsing" <|
            \_ ->
                Expect.ok <| decodeString schemaDecoder metadata
        ]


parseSimpleJson : Test
parseSimpleJson =
    describe "jsonTests" <|
        let
            json =
                """
{
  "@odata.context": "...",
  "value": [
    {
      "Field1": "Value1",
      "Field2": "Value2"
    }
  ]
}
"""

            schema =
                { tables =
                    Dict.fromList
                        [ ( "table1"
                          , { name = "table1"
                            , definition = "TODO"
                            , columns =
                                [ { heading = "Field1", columnType = EdmString }
                                , { heading = "Field2", columnType = EdmString }
                                ]
                            }
                          )
                        ]
                }
        in
        [ test "parseSimpleJson"
            json
            |> decodeString (tableContentsDecoder schema "table1")
            |> Expect.equal
                (Ok { rows = [ [ "Value1", "Value2" ] ] })
        ]

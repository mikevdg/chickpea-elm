module Schema exposing (schemaDecoder)

import Xml.Decode exposing (..)

{- Parsing the schema -}

schemaDecoder : Xml.Decode.Decoder Schema
schemaDecoder =
    path [ "edmx:DataServices", "Schema" ]
        ( Xml.Decode.list decodeSchemaEntry )
    
decodeSchemaEntry : Decoder SchemaEntry
decodeSchemaEntry =
    oneOf [
        decodeEntityType
        , decodeComplexType
    ]

decodeEntityType : Decoder SchemaEntry
decodeEntityType = path ["EntityType"] (list decodeEntityTypeEntry)

decodeComplexType : Decoder SchemaEntry
decodeComplexType = path ["ComplexType"] ComplexType

decodeEntityTypeEntry : Decoder EntityTypeEntry
decodeEntityTypeEntry = oneOf [
    ...working here.
]

type alias Schema = List SchemaEntry

type SchemaEntry = 
    EntityType String EntityTypeEntry
    | ComplexType -- TODO
    | EnumType -- TODO
    | Function
    | Action
    | EntityContainer String (List EntityContainerEntry)

type EntityTypeEntry =
    Key (List PropertyDetails)
    | Property PropertyDetails
    | NavigationProperty PropertyDetails

type alias PropertyDetails = {
    name : String
    , entityType : String -- "type=..."
    , nullable : Bool
 }

type EntityContainerEntry =
    EntitySet EntitySetDetails
    | Singleton -- TODO
    | FunctionImport -- TODO
    | ActionImport -- TODO

type alias EntitySetDetails = {
    name : String
    , entityType : String
 }
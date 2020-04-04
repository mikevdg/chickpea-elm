module ScratchXmlTest exposing (..)

import Expect
import Schema exposing (schemaDecoder)
import Test exposing (..)
import Xml.Decode exposing (Decoder, decodeString, fail, leakyList, map2, path, stringAttr, succeed, with, oneOf, map, string, run )
import XmlParser exposing (..)


parseXmlMetadata : Test
parseXmlMetadata =
    describe "discourse#5412" <|
        let
            exampleXml =
                """
<Schema>
    <EntityType Name="Person">
        <Property>foo</Property>
        <Property>bar</Property>
    </EntityType>
    <ComplexType Name="Location">
        <Property>foo</Property>
        <Property>bar</Property>
    </ComplexType>
    <EntityType Name="Animal">
        <Property>ban</Property>
    </EntityType>
</Schema>
"""
        in
        [ test "proposedDecoder" <|
            \_ ->
                let
                    proposedDecoder =
                        path [] (leakyList decodeSchemaEntry)

                    decodeSchemaEntry =
                        with node <|
                            \n ->
                                case n of
                                    Element "EntityType" _ _ ->
                                        map2 EntityType (stringAttr "Name") decodeEntityTypeEntry

                                    Element "ComplexType" _ _ ->
                                        succeed ComplexType

                                    _ ->
                                        fail "TODO"

                    decodeEntityTypeEntry =
                        oneOf
                            [ path [ "Property" ] <| leakyList <| map Property string

                            -- More to come here
                            ]
                in
                exampleXml
                    |> run proposedDecoder
                    |> Expect.equal
                        (Ok
                            [ EntityType "Person" [ Property "foo", Property "bar" ]
                            , ComplexType
                            , EntityType "Animal" [ Property "ban" ]
                            ]
                        )
        ]

node : Decoder Node
node = Debug.todo ""

type
    SchemaEntry
    -- More to come
    = EntityType String (List EntityTypeEntry)
    | ComplexType


type
    EntityTypeEntry
    -- More to come
    = Property PropertyDetails


type alias PropertyDetails =
    String


result : Result (List a) Xml
result =
    Ok
        { 
            docType = Nothing
            , processingInstructions =
             [ 
                 { name = "xml"
                    , value = "version=\"1.0\" encoding=\"utf-8\""
                 }
            ]
        , root = Element "edmx:Edmx" 
            [ 
                { 
                      name = "xmlns:edmx"
                    , value = "http://docs.oasis-open.org/odata/ns/edmx" 
                },
                { 
                    name = "Version"
                    , value = "4.0" 
                } 
            ]
            [
                Text "\n  "
                , Element 
                    "edmx:DataServices" 
                    [] 
                    [ Text "\n    ", 
                    Element "Schema" 
                        [ 
                            { name = "xmlns", value = "http://docs.oasis-open.org/odata/ns/edm" }
                            , { name = "Namespace", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models" }
                        ] 
                        [ Text "\n      ", 
                            Element "EntityType" [ { name = "Name", value = "Person" } ]
                            [ Text "\n        ", 
                              Element "Key" [] [ Text "\n          ", Element "PropertyRef" [ { name = "Name", value = "UserName" } ] [], Text "\n        " ], Text "\n        ", Element "Property" [ { name = "Name", value = "UserName" }, { name = "Type", value = "Edm.String" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "FirstName" }, { name = "Type", value = "Edm.String" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "LastName" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "MiddleName" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Gender" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.PersonGender" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Age" }, { name = "Type", value = "Edm.Int64" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Emails" }, { name = "Type", value = "Collection(Edm.String)" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "AddressInfo" }, { name = "Type", value = "Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Location)" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "HomeAddress" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Location" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "FavoriteFeature" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Feature" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Features" }, { name = "Type", value = "Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Feature)" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "NavigationProperty" [ { name = "Name", value = "Friends" }, { name = "Type", value = "Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person)" } ] [], Text "\n        ", Element "NavigationProperty" [ { name = "Name", value = "BestFriend" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [], Text "\n        ", Element "NavigationProperty" [ { name = "Name", value = "Trips" }, { name = "Type", value = "Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Trip)" } ] [], Text "\n      " ], Text "\n      ", Element "EntityType" [ { name = "Name", value = "Airline" } ] [ Text "\n        ", Element "Key" [] [ Text "\n          ", Element "PropertyRef" [ { name = "Name", value = "AirlineCode" } ] [], Text "\n        " ], Text "\n        ", Element "Property" [ { name = "Name", value = "AirlineCode" }, { name = "Type", value = "Edm.String" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Name" }, { name = "Type", value = "Edm.String" } ] [], Text "\n      " ], Text "\n      ", Element "EntityType" [ { name = "Name", value = "Airport" } ] [ Text "\n        ", Element "Key" [] [ Text "\n          ", Element "PropertyRef" [ { name = "Name", value = "IcaoCode" } ] [], Text "\n        " ], Text "\n        ", Element "Property" [ { name = "Name", value = "Name" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "IcaoCode" }, { name = "Type", value = "Edm.String" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "IataCode" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Location" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.AirportLocation" } ] [], Text "\n      " ], Text "\n      ", Element "ComplexType" [ { name = "Name", value = "Location" } ] [ Text "\n        ", Element "Property" [ { name = "Name", value = "Address" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "City" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.City" } ] [], Text "\n      " ], Text "\n      ", Element "ComplexType" [ { name = "Name", value = "City" } ] [ Text "\n        ", Element "Property" [ { name = "Name", value = "Name" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "CountryRegion" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Region" }, { name = "Type", value = "Edm.String" } ] [], Text "\n      " ], Text "\n      ", Element "ComplexType" [ { name = "Name", value = "AirportLocation" }, { name = "BaseType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Location" } ] [ Text "\n        ", Element "Property" [ { name = "Name", value = "Loc" }, { name = "Type", value = "Edm.GeographyPoint" } ] [], Text "\n      " ], Text "\n      ", Element "ComplexType" [ { name = "Name", value = "EventLocation" }, { name = "BaseType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Location" } ] [ Text "\n        ", Element "Property" [ { name = "Name", value = "BuildingInfo" }, { name = "Type", value = "Edm.String" } ] [], Text "\n      " ], Text "\n      ", Element "EntityType" [ { name = "Name", value = "Trip" } ] [ Text "\n        ", Element "Key" [] [ Text "\n          ", Element "PropertyRef" [ { name = "Name", value = "TripId" } ] [], Text "\n        " ], Text "\n        ", Element "Property" [ { name = "Name", value = "TripId" }, { name = "Type", value = "Edm.Int32" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "ShareId" }, { name = "Type", value = "Edm.Guid" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Name" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Budget" }, { name = "Type", value = "Edm.Single" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Description" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Tags" }, { name = "Type", value = "Collection(Edm.String)" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "StartsAt" }, { name = "Type", value = "Edm.DateTimeOffset" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "EndsAt" }, { name = "Type", value = "Edm.DateTimeOffset" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "NavigationProperty" [ { name = "Name", value = "PlanItems" }, { name = "Type", value = "Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.PlanItem)" } ] [], Text "\n      " ], Text "\n      ", Element "EntityType" [ { name = "Name", value = "PlanItem" } ] [ Text "\n        ", Element "Key" [] [ Text "\n          ", Element "PropertyRef" [ { name = "Name", value = "PlanItemId" } ] [], Text "\n        " ], Text "\n        ", Element "Property" [ { name = "Name", value = "PlanItemId" }, { name = "Type", value = "Edm.Int32" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "ConfirmationCode" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "StartsAt" }, { name = "Type", value = "Edm.DateTimeOffset" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "EndsAt" }, { name = "Type", value = "Edm.DateTimeOffset" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Duration" }, { name = "Type", value = "Edm.Duration" }, { name = "Nullable", value = "false" } ] [], Text "\n      " ], Text "\n      ", Element "EntityType" [ { name = "Name", value = "Event" }, { name = "BaseType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.PlanItem" } ] [ Text "\n        ", Element "Property" [ { name = "Name", value = "OccursAt" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.EventLocation" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "Description" }, { name = "Type", value = "Edm.String" } ] [], Text "\n      " ], Text "\n      ", Element "EntityType" [ { name = "Name", value = "PublicTransportation" }, { name = "BaseType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.PlanItem" } ] [ Text "\n        ", Element "Property" [ { name = "Name", value = "SeatNumber" }, { name = "Type", value = "Edm.String" } ] [], Text "\n      " ], Text "\n      ", Element "EntityType" [ { name = "Name", value = "Flight" }, { name = "BaseType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.PublicTransportation" } ] [ Text "\n        ", Element "Property" [ { name = "Name", value = "FlightNumber" }, { name = "Type", value = "Edm.String" } ] [], Text "\n        ", Element "NavigationProperty" [ { name = "Name", value = "Airline" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airline" } ] [], Text "\n        ", Element "NavigationProperty" [ { name = "Name", value = "From" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airport" } ] [], Text "\n        ", Element "NavigationProperty" [ { name = "Name", value = "To" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airport" } ] [], Text "\n      " ], Text "\n      ", Element "EntityType" [ { name = "Name", value = "Employee" }, { name = "BaseType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [ Text "\n        ", Element "Property" [ { name = "Name", value = "Cost" }, { name = "Type", value = "Edm.Int64" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "NavigationProperty" [ { name = "Name", value = "Peers" }, { name = "Type", value = "Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person)" } ] [], Text "\n      " ], Text "\n      ", Element "EntityType" [ { name = "Name", value = "Manager" }, { name = "BaseType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [ Text "\n        ", Element "Property" [ { name = "Name", value = "Budget" }, { name = "Type", value = "Edm.Int64" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Property" [ { name = "Name", value = "BossOffice" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Location" } ] [], Text "\n        ", Element "NavigationProperty" [ { name = "Name", value = "DirectReports" }, { name = "Type", value = "Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person)" } ] [], Text "\n      " ], Text "\n      ", Element "EnumType" [ { name = "Name", value = "PersonGender" } ] [ Text "\n        ", Element "Member" [ { name = "Name", value = "Male" }, { name = "Value", value = "0" } ] [], Text "\n        ", Element "Member" [ { name = "Name", value = "Female" }, { name = "Value", value = "1" } ] [], Text "\n        ", Element "Member" [ { name = "Name", value = "Unknow" }, { name = "Value", value = "2" } ] [], Text "\n      " ], Text "\n      ", Element "EnumType" [ { name = "Name", value = "Feature" } ] [ Text "\n        ", Element "Member" [ { name = "Name", value = "Feature1" }, { name = "Value", value = "0" } ] [], Text "\n        ", Element "Member" [ { name = "Name", value = "Feature2" }, { name = "Value", value = "1" } ] [], Text "\n        ", Element "Member" [ { name = "Name", value = "Feature3" }, { name = "Value", value = "2" } ] [], Text "\n        ", Element "Member" [ { name = "Name", value = "Feature4" }, { name = "Value", value = "3" } ] [], Text "\n      " ], Text "\n      ", Element "Function" [ { name = "Name", value = "GetPersonWithMostFriends" } ] [ Text "\n        ", Element "ReturnType" [ { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [], Text "\n      " ], Text "\n      ", Element "Function" [ { name = "Name", value = "GetNearestAirport" } ] [ Text "\n        ", Element "Parameter" [ { name = "Name", value = "lat" }, { name = "Type", value = "Edm.Double" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "Parameter" [ { name = "Name", value = "lon" }, { name = "Type", value = "Edm.Double" }, { name = "Nullable", value = "false" } ] [], Text "\n        ", Element "ReturnType" [ { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airport" } ] [], Text "\n      " ], Text "\n      ", Element "Function" [ { name = "Name", value = "GetFavoriteAirline" }, { name = "IsBound", value = "true" }, { name = "EntitySetPath", value = "person" } ] [ Text "\n        ", Element "Parameter" [ { name = "Name", value = "person" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [], Text "\n        ", Element "ReturnType" [ { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airline" } ] [], Text "\n      " ], Text "\n      ", Element "Function" [ { name = "Name", value = "GetFriendsTrips" }, { name = "IsBound", value = "true" } ] [ Text "\n        ", Element "Parameter" [ { name = "Name", value = "person" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [], Text "\n        ", Element "Parameter" [ { name = "Name", value = "userName" }, { name = "Type", value = "Edm.String" }, { name = "Nullable", value = "false" }, { name = "Unicode", value = "false" } ] [], Text "\n        ", Element "ReturnType" [ { name = "Type", value = "Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Trip)" } ] [], Text "\n      " ], Text "\n      ", Element "Function" [ { name = "Name", value = "GetInvolvedPeople" }, { name = "IsBound", value = "true" } ] [ Text "\n        ", Element "Parameter" [ { name = "Name", value = "trip" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Trip" } ] [], Text "\n        ", Element "ReturnType" [ { name = "Type", value = "Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person)" } ] [], Text "\n      " ], Text "\n      ", Element "Action" [ { name = "Name", value = "ResetDataSource" } ] [], Text "\n      ", Element "Function" [ { name = "Name", value = "UpdatePersonLastName" }, { name = "IsBound", value = "true" } ] [ Text "\n        ", Element "Parameter" [ { name = "Name", value = "person" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [], Text "\n        ", Element "Parameter" [ { name = "Name", value = "lastName" }, { name = "Type", value = "Edm.String" }, { name = "Nullable", value = "false" }, { name = "Unicode", value = "false" } ] [], Text "\n        ", Element "ReturnType" [ { name = "Type", value = "Edm.Boolean" }, { name = "Nullable", value = "false" } ] [], Text "\n      " ], Text "\n      ", Element "Action" [ { name = "Name", value = "ShareTrip" }, { name = "IsBound", value = "true" } ] [ Text "\n        ", Element "Parameter" [ { name = "Name", value = "personInstance" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [], Text "\n        ", Element "Parameter" [ { name = "Name", value = "userName" }, { name = "Type", value = "Edm.String" }, { name = "Nullable", value = "false" }, { name = "Unicode", value = "false" } ] [], Text "\n        ", Element "Parameter" [ { name = "Name", value = "tripId" }, { name = "Type", value = "Edm.Int32" }, { name = "Nullable", value = "false" } ] [], Text "\n      " ], Text "\n      ", Element "EntityContainer" [ { name = "Name", value = "Container" } ] [ Text "\n        ", Element "EntitySet" [ { name = "Name", value = "People" }, { name = "EntityType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [ Text "\n          ", Element "NavigationPropertyBinding" [ { name = "Path", value = "Friends" }, { name = "Target", value = "People" } ] [], Text "\n          ", Element "NavigationPropertyBinding" [ { name = "Path", value = "BestFriend" }, { name = "Target", value = "People" } ] [], Text "\n          ", Element "NavigationPropertyBinding" [ { name = "Path", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Employee/Peers" }, { name = "Target", value = "People" } ] [], Text "\n          ", Element "NavigationPropertyBinding" [ { name = "Path", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Manager/DirectReports" }, { name = "Target", value = "People" } ] [], Text "\n        " ], Text "\n        ", Element "EntitySet" [ { name = "Name", value = "Airlines" }, { name = "EntityType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airline" } ] [ Text "\n          ", Element "Annotation" [ { name = "Term", value = "Org.OData.Core.V1.OptimisticConcurrency" } ] [ Text "\n            ", Element "Collection" [] [ Text "\n              ", Element "PropertyPath" [] [ Text "Name" ], Text "\n            " ], Text "\n          " ], Text "\n        " ], Text "\n        ", Element "EntitySet" [ { name = "Name", value = "Airports" }, { name = "EntityType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airport" } ] [], Text "\n        ", Element "EntitySet" [ { name = "Name", value = "NewComePeople" }, { name = "EntityType", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [], Text "\n        ", Element "Singleton" [ { name = "Name", value = "Me" }, { name = "Type", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person" } ] [], Text "\n        ", Element "FunctionImport" [ { name = "Name", value = "GetPersonWithMostFriends" }, { name = "Function", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.GetPersonWithMostFriends" }, { name = "EntitySet", value = "People" } ] [], Text "\n        ", Element "FunctionImport" [ { name = "Name", value = "GetNearestAirport" }, { name = "Function", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.GetNearestAirport" }, { name = "EntitySet", value = "Airports" } ] [], Text "\n        ", Element "ActionImport" [ { name = "Name", value = "ResetDataSource" }, { name = "Action", value = "Microsoft.OData.Service.Sample.TrippinInMemory.Models.ResetDataSource" } ] [], Text "\n      " ], Text "\n    " ], Text "\n  " ], Text "\n" ]
        }



-- Temporary

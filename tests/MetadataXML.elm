module MetadataXML exposing (metadata)

{- This is the TripPin schema description, from the OData reference service. -}
metadata : String
metadata="""
<?xml version="1.0" encoding="utf-8"?>
<edmx:Edmx xmlns:edmx="http://docs.oasis-open.org/odata/ns/edmx" Version="4.0">
  <edmx:DataServices>
    <Schema xmlns="http://docs.oasis-open.org/odata/ns/edm" Namespace="Microsoft.OData.Service.Sample.TrippinInMemory.Models">
      <EntityType Name="Person">
        <Key>
          <PropertyRef Name="UserName"/>
        </Key>
        <Property Name="UserName" Type="Edm.String" Nullable="false"/>
        <Property Name="FirstName" Type="Edm.String" Nullable="false"/>
        <Property Name="LastName" Type="Edm.String"/>
        <Property Name="MiddleName" Type="Edm.String"/>
        <Property Name="Gender" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.PersonGender" Nullable="false"/>
        <Property Name="Age" Type="Edm.Int64"/>
        <Property Name="Emails" Type="Collection(Edm.String)"/>
        <Property Name="AddressInfo" Type="Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Location)"/>
        <Property Name="HomeAddress" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Location"/>
        <Property Name="FavoriteFeature" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Feature" Nullable="false"/>
        <Property Name="Features" Type="Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Feature)" Nullable="false"/>
        <NavigationProperty Name="Friends" Type="Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person)"/>
        <NavigationProperty Name="BestFriend" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person"/>
        <NavigationProperty Name="Trips" Type="Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Trip)"/>
      </EntityType>
      <EntityType Name="Airline">
        <Key>
          <PropertyRef Name="AirlineCode"/>
        </Key>
        <Property Name="AirlineCode" Type="Edm.String" Nullable="false"/>
        <Property Name="Name" Type="Edm.String"/>
      </EntityType>
      <EntityType Name="Airport">
        <Key>
          <PropertyRef Name="IcaoCode"/>
        </Key>
        <Property Name="Name" Type="Edm.String"/>
        <Property Name="IcaoCode" Type="Edm.String" Nullable="false"/>
        <Property Name="IataCode" Type="Edm.String"/>
        <Property Name="Location" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.AirportLocation"/>
      </EntityType>
      <ComplexType Name="Location">
        <Property Name="Address" Type="Edm.String"/>
        <Property Name="City" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.City"/>
      </ComplexType>
      <ComplexType Name="City">
        <Property Name="Name" Type="Edm.String"/>
        <Property Name="CountryRegion" Type="Edm.String"/>
        <Property Name="Region" Type="Edm.String"/>
      </ComplexType>
      <ComplexType Name="AirportLocation" BaseType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Location">
        <Property Name="Loc" Type="Edm.GeographyPoint"/>
      </ComplexType>
      <ComplexType Name="EventLocation" BaseType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Location">
        <Property Name="BuildingInfo" Type="Edm.String"/>
      </ComplexType>
      <EntityType Name="Trip">
        <Key>
          <PropertyRef Name="TripId"/>
        </Key>
        <Property Name="TripId" Type="Edm.Int32" Nullable="false"/>
        <Property Name="ShareId" Type="Edm.Guid" Nullable="false"/>
        <Property Name="Name" Type="Edm.String"/>
        <Property Name="Budget" Type="Edm.Single" Nullable="false"/>
        <Property Name="Description" Type="Edm.String"/>
        <Property Name="Tags" Type="Collection(Edm.String)"/>
        <Property Name="StartsAt" Type="Edm.DateTimeOffset" Nullable="false"/>
        <Property Name="EndsAt" Type="Edm.DateTimeOffset" Nullable="false"/>
        <NavigationProperty Name="PlanItems" Type="Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.PlanItem)"/>
      </EntityType>
      <EntityType Name="PlanItem">
        <Key>
          <PropertyRef Name="PlanItemId"/>
        </Key>
        <Property Name="PlanItemId" Type="Edm.Int32" Nullable="false"/>
        <Property Name="ConfirmationCode" Type="Edm.String"/>
        <Property Name="StartsAt" Type="Edm.DateTimeOffset" Nullable="false"/>
        <Property Name="EndsAt" Type="Edm.DateTimeOffset" Nullable="false"/>
        <Property Name="Duration" Type="Edm.Duration" Nullable="false"/>
      </EntityType>
      <EntityType Name="Event" BaseType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.PlanItem">
        <Property Name="OccursAt" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.EventLocation"/>
        <Property Name="Description" Type="Edm.String"/>
      </EntityType>
      <EntityType Name="PublicTransportation" BaseType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.PlanItem">
        <Property Name="SeatNumber" Type="Edm.String"/>
      </EntityType>
      <EntityType Name="Flight" BaseType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.PublicTransportation">
        <Property Name="FlightNumber" Type="Edm.String"/>
        <NavigationProperty Name="Airline" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airline"/>
        <NavigationProperty Name="From" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airport"/>
        <NavigationProperty Name="To" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airport"/>
      </EntityType>
      <EntityType Name="Employee" BaseType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person">
        <Property Name="Cost" Type="Edm.Int64" Nullable="false"/>
        <NavigationProperty Name="Peers" Type="Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person)"/>
      </EntityType>
      <EntityType Name="Manager" BaseType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person">
        <Property Name="Budget" Type="Edm.Int64" Nullable="false"/>
        <Property Name="BossOffice" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Location"/>
        <NavigationProperty Name="DirectReports" Type="Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person)"/>
      </EntityType>
      <EnumType Name="PersonGender">
        <Member Name="Male" Value="0"/>
        <Member Name="Female" Value="1"/>
        <Member Name="Unknow" Value="2"/>
      </EnumType>
      <EnumType Name="Feature">
        <Member Name="Feature1" Value="0"/>
        <Member Name="Feature2" Value="1"/>
        <Member Name="Feature3" Value="2"/>
        <Member Name="Feature4" Value="3"/>
      </EnumType>
      <Function Name="GetPersonWithMostFriends">
        <ReturnType Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person"/>
      </Function>
      <Function Name="GetNearestAirport">
        <Parameter Name="lat" Type="Edm.Double" Nullable="false"/>
        <Parameter Name="lon" Type="Edm.Double" Nullable="false"/>
        <ReturnType Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airport"/>
      </Function>
      <Function Name="GetFavoriteAirline" IsBound="true" EntitySetPath="person">
        <Parameter Name="person" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person"/>
        <ReturnType Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airline"/>
      </Function>
      <Function Name="GetFriendsTrips" IsBound="true">
        <Parameter Name="person" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person"/>
        <Parameter Name="userName" Type="Edm.String" Nullable="false" Unicode="false"/>
        <ReturnType Type="Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Trip)"/>
      </Function>
      <Function Name="GetInvolvedPeople" IsBound="true">
        <Parameter Name="trip" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Trip"/>
        <ReturnType Type="Collection(Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person)"/>
      </Function>
      <Action Name="ResetDataSource"/>
      <Function Name="UpdatePersonLastName" IsBound="true">
        <Parameter Name="person" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person"/>
        <Parameter Name="lastName" Type="Edm.String" Nullable="false" Unicode="false"/>
        <ReturnType Type="Edm.Boolean" Nullable="false"/>
      </Function>
      <Action Name="ShareTrip" IsBound="true">
        <Parameter Name="personInstance" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person"/>
        <Parameter Name="userName" Type="Edm.String" Nullable="false" Unicode="false"/>
        <Parameter Name="tripId" Type="Edm.Int32" Nullable="false"/>
      </Action>
      <EntityContainer Name="Container">
        <EntitySet Name="People" EntityType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person">
          <NavigationPropertyBinding Path="Friends" Target="People"/>
          <NavigationPropertyBinding Path="BestFriend" Target="People"/>
          <NavigationPropertyBinding Path="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Employee/Peers" Target="People"/>
          <NavigationPropertyBinding Path="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Manager/DirectReports" Target="People"/>
        </EntitySet>
        <EntitySet Name="Airlines" EntityType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airline">
          <Annotation Term="Org.OData.Core.V1.OptimisticConcurrency">
            <Collection>
              <PropertyPath>Name</PropertyPath>
            </Collection>
          </Annotation>
        </EntitySet>
        <EntitySet Name="Airports" EntityType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Airport"/>
        <EntitySet Name="NewComePeople" EntityType="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person"/>
        <Singleton Name="Me" Type="Microsoft.OData.Service.Sample.TrippinInMemory.Models.Person"/>
        <FunctionImport Name="GetPersonWithMostFriends" Function="Microsoft.OData.Service.Sample.TrippinInMemory.Models.GetPersonWithMostFriends" EntitySet="People"/>
        <FunctionImport Name="GetNearestAirport" Function="Microsoft.OData.Service.Sample.TrippinInMemory.Models.GetNearestAirport" EntitySet="Airports"/>
        <ActionImport Name="ResetDataSource" Action="Microsoft.OData.Service.Sample.TrippinInMemory.Models.ResetDataSource"/>
      </EntityContainer>
    </Schema>
  </edmx:DataServices>
</edmx:Edmx>
"""
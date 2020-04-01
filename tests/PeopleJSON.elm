module PeopleJSON exposing (people)

people : String
people = """
{
  "@odata.context": "https://services.odata.org/TripPinRESTierService/(S(mly0lemodbb4rmdukjup4lcm))/$metadata#People",
  "value": [
    {
      "UserName": "russellwhyte",
      "FirstName": "Russell",
      "LastName": "Whyte",
      "MiddleName": null,
      "Gender": "Male",
      "Age": null,
      "Emails": [
        "Russell@example.com",
        "Russell@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [
        "Feature1",
        "Feature2"
      ],
      "AddressInfo": [
        {
          "Address": "187 Suffolk Ln.",
          "City": {
            "Name": "Boise",
            "CountryRegion": "United States",
            "Region": "ID"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "scottketchum",
      "FirstName": "Scott",
      "LastName": "Ketchum",
      "MiddleName": null,
      "Gender": "Male",
      "Age": null,
      "Emails": [
        "Scott@example.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "2817 Milton Dr.",
          "City": {
            "Name": "Albuquerque",
            "CountryRegion": "United States",
            "Region": "NM"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "ronaldmundy",
      "FirstName": "Ronald",
      "LastName": "Mundy",
      "MiddleName": null,
      "Gender": "Male",
      "Age": null,
      "Emails": [
        "Ronald@example.com",
        "Ronald@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "187 Suffolk Ln.",
          "City": {
            "Name": "Boise",
            "CountryRegion": "United States",
            "Region": "ID"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "javieralfred",
      "FirstName": "Javier",
      "LastName": "Alfred",
      "MiddleName": null,
      "Gender": "Male",
      "Age": null,
      "Emails": [
        "Javier@example.com",
        "Javier@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "89 Jefferson Way Suite 2",
          "City": {
            "Name": "Portland",
            "CountryRegion": "United States",
            "Region": "WA"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "willieashmore",
      "FirstName": "Willie",
      "LastName": "Ashmore",
      "MiddleName": null,
      "Gender": "Male",
      "Age": null,
      "Emails": [],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [],
      "HomeAddress": null
    },
    {
      "UserName": "vincentcalabrese",
      "FirstName": "Vincent",
      "LastName": "Calabrese",
      "MiddleName": null,
      "Gender": "Male",
      "Age": null,
      "Emails": [
        "Vincent@example.com",
        "Vincent@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "55 Grizzly Peak Rd.",
          "City": {
            "Name": "Butte",
            "CountryRegion": "United States",
            "Region": "MT"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "clydeguess",
      "FirstName": "Clyde",
      "LastName": "Guess",
      "MiddleName": null,
      "Gender": "Male",
      "Age": null,
      "Emails": [],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [],
      "HomeAddress": {
        "Address": null,
        "City": null
      }
    },
    {
      "UserName": "keithpinckney",
      "FirstName": "Keith",
      "LastName": "Pinckney",
      "MiddleName": null,
      "Gender": "Male",
      "Age": null,
      "Emails": [
        "Keith@example.com",
        "Keith@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "55 Grizzly Peak Rd.",
          "City": {
            "Name": "Butte",
            "CountryRegion": "United States",
            "Region": "MT"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "marshallgaray",
      "FirstName": "Marshall",
      "LastName": "Garay",
      "MiddleName": null,
      "Gender": "Male",
      "Age": null,
      "Emails": [
        "Marshall@example.com",
        "Marshall@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "55 Grizzly Peak Rd.",
          "City": {
            "Name": "Butte",
            "CountryRegion": "United States",
            "Region": "MT"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "ryantheriault",
      "FirstName": "Ryan",
      "LastName": "Theriault",
      "MiddleName": null,
      "Gender": "Male",
      "Age": null,
      "Emails": [
        "Ryan@example.com",
        "Ryan@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "55 Grizzly Peak Rd.",
          "City": {
            "Name": "Butte",
            "CountryRegion": "United States",
            "Region": "MT"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "elainestewart",
      "FirstName": "Elaine",
      "LastName": "Stewart",
      "MiddleName": null,
      "Gender": "Female",
      "Age": null,
      "Emails": [
        "Elaine@example.com",
        "Elaine@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "55 Grizzly Peak Rd.",
          "City": {
            "Name": "Butte",
            "CountryRegion": "United States",
            "Region": "MT"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "salliesampson",
      "FirstName": "Sallie",
      "LastName": "Sampson",
      "MiddleName": null,
      "Gender": "Female",
      "Age": null,
      "Emails": [
        "Sallie@example.com",
        "Sallie@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "87 Polk St. Suite 5",
          "City": {
            "Name": "San Francisco",
            "CountryRegion": "United States",
            "Region": "CA"
          }
        },
        {
          "Address": "89 Chiaroscuro Rd.",
          "City": {
            "Name": "Portland",
            "CountryRegion": "United States",
            "Region": "OR"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "jonirosales",
      "FirstName": "Joni",
      "LastName": "Rosales",
      "MiddleName": null,
      "Gender": "Female",
      "Age": null,
      "Emails": [
        "Joni@example.com",
        "Joni@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "55 Grizzly Peak Rd.",
          "City": {
            "Name": "Butte",
            "CountryRegion": "United States",
            "Region": "MT"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "georginabarlow",
      "FirstName": "Georgina",
      "LastName": "Barlow",
      "MiddleName": null,
      "Gender": "Female",
      "Age": null,
      "Emails": [
        "Georgina@example.com",
        "Georgina@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "55 Grizzly Peak Rd.",
          "City": {
            "Name": "Butte",
            "CountryRegion": "United States",
            "Region": "MT"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "angelhuffman",
      "FirstName": "Angel",
      "LastName": "Huffman",
      "MiddleName": null,
      "Gender": "Female",
      "Age": null,
      "Emails": [
        "Angel@example.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "55 Grizzly Peak Rd.",
          "City": {
            "Name": "Butte",
            "CountryRegion": "United States",
            "Region": "MT"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "laurelosborn",
      "FirstName": "Laurel",
      "LastName": "Osborn",
      "MiddleName": null,
      "Gender": "Female",
      "Age": null,
      "Emails": [
        "Laurel@example.com",
        "Laurel@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "87 Polk St. Suite 5",
          "City": {
            "Name": "San Francisco",
            "CountryRegion": "United States",
            "Region": "CA"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "sandyosborn",
      "FirstName": "Sandy",
      "LastName": "Osborn",
      "MiddleName": null,
      "Gender": "Female",
      "Age": null,
      "Emails": [
        "Sandy@example.com",
        "Sandy@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "87 Polk St. Suite 5",
          "City": {
            "Name": "San Francisco",
            "CountryRegion": "United States",
            "Region": "CA"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "UserName": "ursulabright",
      "FirstName": "Ursula",
      "LastName": "Bright",
      "MiddleName": null,
      "Gender": "Female",
      "Age": null,
      "Emails": [
        "Ursula@example.com",
        "Ursula@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "AddressInfo": [
        {
          "Address": "87 Polk St. Suite 5",
          "City": {
            "Name": "San Francisco",
            "CountryRegion": "United States",
            "Region": "CA"
          }
        }
      ],
      "HomeAddress": null
    },
    {
      "@odata.type": "#Microsoft.OData.Service.Sample.TrippinInMemory.Models.Manager",
      "UserName": "genevievereeves",
      "FirstName": "Genevieve",
      "LastName": "Reeves",
      "MiddleName": null,
      "Gender": "Female",
      "Age": null,
      "Emails": [
        "Genevieve@example.com",
        "Genevieve@contoso.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "Budget": 0,
      "AddressInfo": [
        {
          "Address": "87 Polk St. Suite 5",
          "City": {
            "Name": "San Francisco",
            "CountryRegion": "United States",
            "Region": "CA"
          }
        }
      ],
      "HomeAddress": null,
      "BossOffice": null
    },
    {
      "@odata.type": "#Microsoft.OData.Service.Sample.TrippinInMemory.Models.Employee",
      "UserName": "kristakemp",
      "FirstName": "Krista",
      "LastName": "Kemp",
      "MiddleName": null,
      "Gender": "Female",
      "Age": null,
      "Emails": [
        "Krista@example.com"
      ],
      "FavoriteFeature": "Feature1",
      "Features": [],
      "Cost": 0,
      "AddressInfo": [
        {
          "Address": "87 Polk St. Suite 5",
          "City": {
            "Name": "San Francisco",
            "CountryRegion": "United States",
            "Region": "CA"
          }
        }
      ],
      "HomeAddress": null
    }
  ]
}
"""
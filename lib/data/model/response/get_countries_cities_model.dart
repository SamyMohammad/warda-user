// To parse this JSON data, do
//
//     final getCountriesCitiesModel = getCountriesCitiesModelFromJson(jsonString);

import 'dart:convert';

GetCountriesCitiesModel getCountriesCitiesModelFromJson(String str) =>
    GetCountriesCitiesModel.fromJson(json.decode(str));

String getCountriesCitiesModelToJson(GetCountriesCitiesModel data) =>
    json.encode(data.toJson());

class GetCountriesCitiesModel {
  final List<Country> countries;

  GetCountriesCitiesModel({
    required this.countries,
  });

  factory GetCountriesCitiesModel.fromJson(Map<String, dynamic> json) =>
      GetCountriesCitiesModel(
        countries: json["countries"] == null
            ? []
            : List<Country>.from(
                json["countries"].map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countries": countries == null
            ? []
            : List<dynamic>.from(countries.map((x) => x.toJson())),
      };
}

class Country {
  final int id;
  final String name;
  final String flag;
  final String flagLink;
  final List<City> cities;

  Country({
    required this.id,
    required this.name,
    required this.flag,
    required this.flagLink,
    required this.cities,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        flag: json["flag"],
        flagLink: json["flag_link"],
        cities: json["cities"] == null
            ? []
            : List<City>.from(json["cities"].map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "flag": flag,
        "flag_link": flagLink,
        "cities": cities == null
            ? []
            : List<dynamic>.from(cities.map((x) => x.toJson())),
      };
}

class City {
  final int id;
  final String name;
  final int countryId;

  City({
    required this.id,
    required this.name,
    required this.countryId,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        countryId: json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_id": countryId,
      };
}

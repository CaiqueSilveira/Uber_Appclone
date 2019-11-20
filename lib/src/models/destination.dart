class Destination{

  String _street;
  String _number;
  String _city;
  String _neighborhood;
  String _zip;
  double _lat;
  double _lng;

  Destination();

  String get street => _street;
  set street(String street) => _street = street;

  String get number => _number;
  set number(String number) => _number = number;

  String get city => _city;
  set city(String city) => _city = city;

  String get neighborhood => _neighborhood;
  set neighborhood(String neighborhood) =>_neighborhood = neighborhood;

  String get zip => _zip;
  set zip(String zip) => _zip = zip;

  double get lat => _lat;
  set lat(double lat) => _lat = lat;

  double get lng => _lng;
  set lng(double lng) => _lng = lng;
 
}
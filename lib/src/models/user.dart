class User {
  String _id;
  String _name;
  String _email;
  String _password;
  String _phone;
  String _type;
  String _photoUrl;
  double _lat;
  double _lng;

  User();

  User.database(String id, String name, String email, String phone, bool type, String photoUrl) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.phone = phone;
    this._type = checkTypeUser(type);
    this.photoUrl = photoUrl;
  }

  String get id => _id;
  set id(String id) => _id = id;

  String get name => _name;
  set name(String name) => _name = name;

  String get email => _email;
  set email(String email) => _email = email;

  String get password => _password;
  set password(String password) => _password = password;

  String get phone => _phone;
  set phone(String phone) => _phone = phone;

  String get type => _type;
  set type(String type) => _type = type;

  String get photoUrl => _photoUrl;
  set photoUrl(String photoUrl) => _photoUrl = photoUrl;

  double get lat => _lat;
  set lat(double lat) => _lat = lat;

  double get lng => _lng;
  set lng(double lng) => _lng = lng;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "name": this.name,
      "email": this.email,
      "phone": this.phone,
      "type": this.type,
      "photoUrl": this.photoUrl,
      "lat": this.lat,
      "lng": this.lng,
    };
    return map;
  }

  User.fromMap(Map map) {
    _id = map['id'];
    _name = map['name'];
    _email = map['email'];
    _phone = map['phone'];
    _type = map['type'];
    _photoUrl = map['photoUrl'];
    _lat = map['lat'];
    _lng = map['lng'];
  }

  String checkTypeUser(bool value) {
    return value ? "motorista" : "passageiro";
  }

  @override
  String toString() {
    return "User [id: $id, name: $name, email: $email, type: $type, lat: $lat, lng: $lng]";
  }
}

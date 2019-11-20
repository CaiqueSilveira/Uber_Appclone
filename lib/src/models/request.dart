import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_appclone/src/models/destination.dart';
import 'package:uber_appclone/src/models/user.dart';

class Request {
  String _id;
  String _status;
  User _rider;
  User _driver;
  Destination _destination;

  Request(){
    Firestore db = Firestore.instance;
    DocumentReference ref = db.collection("requisicoes").document();
    this.id = ref.documentID;
  }

  String get id => _id;
  set id(String id) => _id = id;

  String get status => _status;
  set status(String status) => _status = status;

  User get rider => _rider;
  set rider(User rider) => _rider = rider;

  User get driver => _driver;
  set driver(User driver) => _driver = driver;

  Destination get destination => _destination;
  set destination(Destination destination) => _destination = destination;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> riderData = {
      "id": this.rider.id,
      "name": this.rider.name,
      "email": this.rider.email,
      "phone": this.rider.phone,
      "type": this.rider.type,
      "photoUrl": this.rider.photoUrl,
      "lat": this.rider.lat,
      "lng": this.rider.lng,
    };

    Map<String, dynamic> destinationData = {
      "street": this.destination.street,
      "number": this.destination.number,
      "neighborhood": this.destination.neighborhood,
      "city": this.destination.city,
      "zip": this.destination.zip,
      "lat": this.destination.lat,
      "lng": this.destination.lng,
    };

    Map<String, dynamic> requestData = {
      "id": this.id,
      "status": this.status,
      "rider": riderData,
      "driver": null,
      "destination": destinationData,
    };
    return requestData;
  }
}

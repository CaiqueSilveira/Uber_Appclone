import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uber_appclone/src/models/user.dart';

class UserRepository {
  final _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;
  FirebaseUser _firebaseUser;

  Future<User> getUserDatabase() async {
    _firebaseUser = await _auth.currentUser();
    String id = _firebaseUser.uid;

    DocumentSnapshot snapshot =
        await _db.collection("users").document(id).get();

    User user = User.fromMap(snapshot.data);

    return user;
  }

  updateLocationData(String idRequest, double lat, double lng) async {
    User driver = await getUserDatabase();
    driver.lat = lat;
    driver.lng = lng;

    _db
        .collection("requests")
        .document(idRequest)
        .updateData({"motorista": driver.toMap()});
  }
}

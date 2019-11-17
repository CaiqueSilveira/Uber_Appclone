import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uber_appclone/src/models/user.dart';

class Authentication {
  final _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser _firebaseUser;
  String verificationId;

  Future<AuthResult> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return authResult;
  }

  Future<AuthResult> signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return authResult;
  }

  Future<void> verifyPhoneNumner(String phoneNumber) async {
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      print('Credentaial: $phoneAuthCredential');
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print(
          'Verificação falhou. Código: ${authException.code}. Mensagem: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print('Por favor, verifique o código enviado.');
      print(verificationId);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print(verificationId);
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

    return verificationCompleted;
  }

  Future<FirebaseUser> currentUser() async {
    _firebaseUser = await _auth.currentUser();
    return _firebaseUser;
  }

  Future<void> confirmeUserByPhone(String name, String email, bool type) async {
    _firebaseUser = await _auth.currentUser();
    User user = new User.database(_firebaseUser.uid, name,
        email, _firebaseUser.phoneNumber, type, _firebaseUser.photoUrl);
    _db.collection('users').document(user.id).setData(user.toMap());
  }

  Future<void> confirmeUserByGoogle(String phone, bool type) async {
    _firebaseUser = await _auth.currentUser();
    User user = new User.database(_firebaseUser.uid, _firebaseUser.displayName,
        _firebaseUser.email, phone, type, _firebaseUser.photoUrl);
    _db.collection('users').document(user.id).setData(user.toMap());
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
  }
}

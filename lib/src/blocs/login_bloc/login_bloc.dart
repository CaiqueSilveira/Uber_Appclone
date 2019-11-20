import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uber_appclone/src/blocs/login_bloc/login_validators.dart';
import 'package:uber_appclone/src/page/ui_login/login_page.dart';
import 'package:uber_appclone/src/page/ui_login/sm_confirme_page.dart';
import 'package:uber_appclone/src/services/authentication/authentication.dart';
import 'package:uber_appclone/src/services/userRepository/userRepository.dart';

class LoginBloc with Validators {
  final Authentication _authentication = new Authentication();
  final UserRepository _repository = new UserRepository();

  // Controllers
  final _userController = BehaviorSubject<FirebaseUser>();
  final _typeController = BehaviorSubject<bool>.seeded(false);
  final _phoneController = BehaviorSubject<String>();
  final _smsController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();

  final _verificationIdController = BehaviorSubject<String>();

  // Streams
  Stream<FirebaseUser> get firebaseUser => _userController.stream;
  Stream<String> get phone => _phoneController.stream;
  Stream<String> get sms => _smsController.stream;
  Stream<String> get verificationId => _verificationIdController.stream;
  Stream<String> get name => _nameController.stream;
  Stream<String> get email => _emailController.stream;
  Stream<bool> get type => _typeController.stream;

  // Sink
  Function(String) get inputPhone => _phoneController.sink.add;
  Function(bool) get inputType => _typeController.sink.add;
  Function(String) get inputSms => _smsController.sink.add;
  Function(String) get inputEmail => _emailController.sink.add;
  Function(String) get inputName => _nameController.sink.add;

  onClickGoogle(BuildContext context) async {
    await _authentication.signInWithGoogle().then(
      (value) {
        _userController.add(value.user);
        if (value.additionalUserInfo.isNewUser) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SmConfirmePage(
                currentUser: value.user,
              ),
            ),
          );
        } else {
          _repository.getUserDatabase().then((value) {
            switch (value.type) {
              case "motorista":
                Navigator.pushReplacementNamed(context, "/painel-motorista", arguments: value);
                break;
              case "passageiro":
                Navigator.pushReplacementNamed(context, "/painel-passageiro", arguments: value);
                break;
            }
          });
        }
      },
    );
  }

  onClickPhone(BuildContext context) async {
    final br = '+55';
    final phone = (br + _phoneController.value);
    await _authentication.verifyPhoneNumner(phone);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SmConfirmePage(
          currentUser: _userController.value,
        ),
      ),
    );
  }

  onClickConfirmeUserByPhone(BuildContext context) async {
    final name = _nameController.value;
    final email = _emailController.value;
    final type = _typeController.value;
    await _authentication.confirmeUserByPhone(name, email, type);
    await _authentication.currentUser().then((value) {
      _userController.add(value);
      _repository.getUserDatabase().then((user) {
        switch (user.type) {
          case "motorista":
            Navigator.pushReplacementNamed(context, "/painel-motorista", arguments: value);
            break;
          case "passageiro":
            Navigator.pushReplacementNamed(context, "/painel-passageiro", arguments: value);
            break;
        }
      });
    });
  }

  onClickConfirmeUser(BuildContext context) async {
    final phone = _phoneController.value;
    final type = _typeController.value;
    await _authentication.confirmeUserByGoogle(phone, type);
    _repository.getUserDatabase().then((value) {
      switch (value.type) {
        case "motorista":
          Navigator.pushReplacementNamed(context, "/painel-motorista", arguments: value);
          break;
        case "passageiro":
          Navigator.pushReplacementNamed(context, "/painel-passageiro", arguments: value);
          break;
      }
    });
  }

  onClickSignOut(BuildContext context) async {
    await _authentication.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void dispose() {
    _nameController.close();
    _emailController.close();
    _phoneController.close();
    _smsController.close();
    _verificationIdController.close();
    _typeController.close();
    _userController.close();
  }
}

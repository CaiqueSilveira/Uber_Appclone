import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uber_appclone/src/models/user.dart';
import 'package:uber_appclone/src/page/ui_drawer_componets/configuracao_page.dart';
import 'package:uber_appclone/src/page/ui_profile/edit_profile.dart';
import 'package:uber_appclone/src/services/userRepository/userRepository.dart';

class ProfileBloc {
  final UserRepository _userRepository = new UserRepository();

  final _userController = BehaviorSubject<User>();
  ValueObservable<User> get user => _userController.stream;
  StreamSink<User> get userChange => _userController.sink;

  onClickeEditProfile(BuildContext context) async {
    await _userRepository.getUserDatabase().then(
      (value) {
        userChange.add(value);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditProfilePage(
              currentUser: value,
            ),
          ),
        );
      },
    );
  }

  onClickeSettingtProfile(BuildContext context) async {
    await _userRepository.getUserDatabase().then(
      (value) {
        userChange.add(value);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SettingPage(
              user: value,
            ),
          ),
        );
      },
    );
  }

  onClickUpdateUser() {}

  dispose() {
    _userController.close();
  }
}

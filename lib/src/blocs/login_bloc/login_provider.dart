import 'package:flutter/material.dart';
import 'package:uber_appclone/src/blocs/login_bloc/login_bloc.dart';

class LoginProvider extends InheritedWidget {
  final LoginBloc bloc;

  LoginProvider({Key key, Widget child})
      : bloc = LoginBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LoginProvider)
            as LoginProvider)
        .bloc;
  }
}

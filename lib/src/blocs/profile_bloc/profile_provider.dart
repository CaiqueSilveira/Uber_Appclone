import 'package:flutter/material.dart';
import 'package:uber_appclone/src/blocs/profile_bloc/profile_bloc.dart';

class ProfileProvider extends InheritedWidget {
  final ProfileBloc bloc;

  ProfileProvider({Key key, Widget child})
      : bloc = ProfileBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ProfileBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ProfileProvider)
            as ProfileProvider)
        .bloc;
  }
}

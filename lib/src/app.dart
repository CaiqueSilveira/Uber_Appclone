import 'package:flutter/material.dart';
import 'package:uber_appclone/src/page/ui_login/login_page.dart';
import 'routes.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Uber App Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        initialRoute: "/",
        home: LoginPage(),
        onGenerateRoute: Routes.createRoutes,
    );
  }
}

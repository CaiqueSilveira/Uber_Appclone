import 'package:flutter/material.dart';
import 'package:uber_appclone/src/page/ui_home/driver_dashboard.dart';
import 'package:uber_appclone/src/page/ui_home/rider_dashboard.dart';
import 'package:uber_appclone/src/page/ui_login/login_page.dart';
import 'package:uber_appclone/src/page/ui_race/race.dart';

class Routes {
  static Route<dynamic> createRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => LoginPage());
      case "/painel-motorista":
        return MaterialPageRoute(builder: (_) => PainelMotorista(user: args,));
      case "/painel-passageiro":
        return MaterialPageRoute(builder: (_) => RiderDashboard(
          user: args,
        ));
      case "/corrida":
        return MaterialPageRoute(builder: (_) => Corrida(args));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Uber Clone"),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}

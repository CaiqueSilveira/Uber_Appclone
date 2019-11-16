import 'package:flutter/material.dart';
import 'package:uber_appclone/page/ui_home/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Painel(),
    );
  }
}

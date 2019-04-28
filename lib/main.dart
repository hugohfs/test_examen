
import 'package:flutter/material.dart';
import 'package:test_examen/pages/home_page.dart';
import 'package:test_examen/pages/root_page.dart';
import 'package:test_examen/services/authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'HFS Flutter App',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth())
      //home: new HomePage()
    );
  }
}

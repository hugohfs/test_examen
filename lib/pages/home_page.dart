import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:test_examen/components/drawer.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget _showLogo() {
    return new Hero(
      tag: 'hero', //TODO:
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/test-exam.png'),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(g.APPBAR_MENU_PRINCIPAL),
        actions: <Widget>[
          IconButton(
              icon: Icon((Icons.close)), onPressed: () => SystemNavigator.pop())
        ],
      ),
      drawer: new MyDrawer(),
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(children: <Widget>[
                _showLogo(),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                    child: new Center(
                        child: Text("Bienvenido a HFS test de examen.",
                            style: new TextStyle(fontSize: 22.0)))),
                /*Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                    child: new Center(
                        child: Text("Puedes navegar por la opciones del menú.",
                            style: new TextStyle(fontSize: 22.0))))*/
              ]),
            )
          ],
        ),
      ),
    );
  }
}
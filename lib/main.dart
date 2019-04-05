// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold] and the [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_examen/pages/anadir_pregunta_page.dart';
import 'package:test_examen/pages/lista_preguntas_page.dart';
import 'package:test_examen/globals.dart' as g;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test examen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  Widget _showLogo() {
    return new Hero(
      tag: 'hero', //TODO:
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
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
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(g.userAccountName),
              accountEmail: Text(g.userAccountEmail),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(g.userAccountEmail.length > 0
                    ? g.userAccountEmail[0].toUpperCase()
                    : ""),
              ),
            ),
            ListTile(
                title: Text(g.DRAWER_ANADIR_PREGUNTAS),
                trailing: Icon(Icons.add),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AnadirPreguntaPage()));
                }),
            ListTile(
                title: Text(g.DRAWER_LISTA_DE_PREGUNTAS),
                trailing: Icon(Icons.playlist_add_check),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ListaPreguntasPage()));
                }),
            ListTile(
              title: Text("Close"),
              trailing: Icon(Icons.close),
              onTap: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
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

import 'package:flutter/services.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:flutter/material.dart';
import 'package:test_examen/pages/anadir_pregunta_page.dart';
import 'package:test_examen/pages/home_page.dart';
import 'package:test_examen/pages/lista_preguntas_page.dart';

class MyDrawer extends Drawer {
  MyDrawer({Key key, Widget child}) : super(key: key, child: child);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(g.userAccountName),
            accountEmail: Text(g.userAccountEmail),
            /*decoration: new BoxDecoration(
              image: new DecorationImage(
                fit: BoxFit.fill,
                  image: NetworkImage(g.photoUrl)
              )
            ),*/
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(g.photoUrl),
              /*child: Text(
                  g.userAccountEmail.length > 0
                  ? g.userAccountEmail[0].toUpperCase()
                  : ""),*/
            ),
          ),
          ListTile(
              title: Text(g.DRAWER_HOME),
              trailing: Icon(Icons.home),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
              }),
          /*ListTile(
              title: Text(g.DRAWER_ANADIR_PREGUNTAS),
              trailing: Icon(Icons.add),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AnadirPreguntaPage()));
              }),*/
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
          ),
          ListTile(
            title: Text("Exit"),
            trailing: Icon(Icons.exit_to_app),
            onTap: () => SystemNavigator.pop(),
          )
        ],
      ),
    );
  }
}
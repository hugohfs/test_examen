import 'package:flutter/services.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:flutter/material.dart';
import 'package:test_examen/pages/anadir_pregunta_page.dart';
import 'package:test_examen/pages/home_page.dart';
import 'package:test_examen/pages/lista_preguntas_page.dart';
import 'package:test_examen/pages/root_page.dart';
import 'package:test_examen/services/authentication.dart';

class MyDrawer extends Drawer {
  //MyDrawer({Key key, Widget child}) : super(key: key, child: child);

  MyDrawer({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(g.userInfoDetails.displayName),
            accountEmail: Text(g.userInfoDetails.email),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(g.userInfoDetails.photoUrl),
              /*child: Text(
                  g.userAccountEmail.length > 0
                  ? g.userAccountEmail[0].toUpperCase()
                  : ""),*/
            ),
            /*decoration: new BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(g.photoUrl)
                )
            ),*/
          ),
          ListTile(
              title: Text(g.DRAWER_INICIO),
              trailing: Icon(Icons.home),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(auth: auth, userId: userId, onSignedOut: onSignedOut)));
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
                    builder: (BuildContext context) => ListaPreguntasPage(auth: auth, userId: userId, onSignedOut: onSignedOut)));
              }),
          Divider(),
          /*ListTile(
            title: Text(g.DRAWER_CERRAR),
            trailing: Icon(Icons.close),
            onTap: () => Navigator.of(context).pop(),
          ),*/
          ListTile(
            title: Text(g.DRAWER_CERRAR_SESISON),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pop();
              auth.signOut();
              auth.signOutGoogle();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new RootPage(auth: new Auth())));

              /*Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => new RootPage(auth: new Auth())));*/
              },
          ),
          ListTile(
            title: Text(g.DRAWER_SALIR),
            trailing: Icon(Icons.close),
            onTap: () => SystemNavigator.pop(),
          )
        ],
      ),
    );
  }
}
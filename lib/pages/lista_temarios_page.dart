import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:test_examen/components/drawer.dart';
import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:flutter/material.dart';
import 'package:test_examen/model/temario.dart';
import 'package:test_examen/model/usuario.dart';
import 'package:test_examen/pages/pregunta_page.dart';
import 'package:test_examen/services/authentication.dart';

class ListaTemariosPage extends StatefulWidget {
  ListaTemariosPage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ListaTemariosPageState();
}

class _ListaTemariosPageState extends State<ListaTemariosPage> {
  List<Pregunta> _preguntas = List();
  List<Pregunta> _preguntasUsuario = List();
  List<Pregunta> _preguntasGratis = List();
  List<Tema> _temarios = List();
  Usuario _usuario = Usuario('','',[]);

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onPreguntaAddedSubscription;
  StreamSubscription<Event> _onPreguntaChangedSubscription;
  StreamSubscription<Event> _onTemarioAddedSubscription;
  StreamSubscription<Event> _onTemarioChangedSubscription;
  StreamSubscription<Event> _onUsuarioAddedSubscription;
  StreamSubscription<Event> _onUsuarioChangedSubscription;
  Query _preguntasQuery;
  Query _preguntasGratisQuery;
  Query _usuarioQuery;
  Query _temarioQuery;

  @override
  void initState() {
    super.initState();

    /*_database.reference().child("testExamen/usuarios/" + g.userInfoDetails.uid).once().then((DataSnapshot snapshot) {
      print('usuario: ${snapshot.value}');
      setState(() {
        _usuario = Usuario.fromSnapshot(snapshot);
      });
    });*/

    _preguntas = List();
    _preguntasUsuario = List();
    _preguntasGratis = List();
    _temarios = List();

    _preguntasQuery = _database
        .reference()
        .child("testExamen/preguntas")
        ;

    _usuarioQuery = _database
        .reference()
        .child("testExamen/usuarios/" + g.userInfoDetails.uid)
    ;

    _temarioQuery = _database
        .reference()
        .child("testExamen/temario")
    ;

    _onPreguntaAddedSubscription =
        _preguntasQuery.onChildAdded.listen(_onPreguntaEntryAdded);
    _onPreguntaChangedSubscription =
        _preguntasQuery.onChildChanged.listen(_onPreguntaEntryChanged);

    _onTemarioAddedSubscription =
        _temarioQuery.onChildAdded.listen(_onTemarioEntryAdded);
    _onTemarioChangedSubscription =
        _temarioQuery.onChildChanged.listen(_onTemarioEntryChanged);

    _preguntasGratisQuery = _database
        .reference()
        .child("testExamen/preguntasGratis")
        ;

    _preguntasGratisQuery.onChildAdded.listen((Event event) {
      setState(() {
        Pregunta p = Pregunta.fromSnapshot(event.snapshot);
        _preguntasGratis.add(p);
        _preguntasUsuario.add(p);
      });
    });

  }

  @override
  void dispose() {
    _onPreguntaAddedSubscription.cancel();
    _onPreguntaChangedSubscription.cancel();
    _onTemarioAddedSubscription.cancel();
    _onTemarioChangedSubscription.cancel();
    _onUsuarioAddedSubscription.cancel();
    _onUsuarioChangedSubscription.cancel();
    super.dispose();
  }

  _onPreguntaEntryAdded(Event event) {
    setState(() {
      Pregunta p = Pregunta.fromSnapshot(event.snapshot);
      _preguntas.add(p);
      if(p.usuariosPregunta.contains(g.userInfoDetails.uid)) {
        _preguntasUsuario.add(p);
      }
    });
  }

  _onPreguntaEntryChanged(Event event) {
    var old = _preguntas.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _preguntas[_preguntas.indexOf(old)] =
          Pregunta.fromSnapshot(event.snapshot);
    });
  }

  _onTemarioEntryAdded(Event event) {
    setState(() {
      _temarios.add(Tema.fromSnapshot(event.snapshot));
    });
  }

  _onTemarioEntryChanged(Event event) {
    var old = _temarios.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _temarios[_temarios.indexOf(old)] =
          Tema.fromSnapshot(event.snapshot);
    });
  }

  /*_onUsuarioEntryAdded(Event event) {
    setState(() {
      _usuario = Usuario.fromSnapshot(event.snapshot);
    });
  }

  _onUsuarioEntryChanged(Event event) {
    setState(() {
      _usuario = Usuario.fromSnapshot(event.snapshot);
    });
  }*/

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _temarios.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              _temarios[index].nombre ?? '',
              style: TextStyle(fontSize: 20.0),
            ),
            /*subtitle: _temarios[index].respuestas != null
                ? Text(_temarios[index].respuestas[0] ?? '' +
                    ", " +
                  _temarios[index].respuestas[1] ?? '' +
                    ", " +
                  _temarios[index].respuestas[2] ?? '')
                : Text(''),*/
            /*onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PreguntaPage(
                        pregunta: _temarios[index],
                        auth: widget.auth,
                        userId: widget.userId,
                        onSignedOut: widget.onSignedOut))),*/
            /*trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.grey, size: 20.0),
                onPressed: () {
                  eliminarPregunta(index);
                }),*/
          );
        });
  }

  /*eliminarPregunta(int index) {
    String key = _preguntas[index].key;
    _listaPreguntasRef.child("testExamen").child(key).remove().then((_) {
      print("Delete $key successful");
      setState(() {
        _preguntas.removeAt(index);
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(g.APPBAR_LISTA_DE_TEMAS)),
      body: _buildBody(context),
      drawer: new MyDrawer(
          auth: widget.auth,
          userId: widget.userId,
          onSignedOut: widget.onSignedOut),
    );
  }
}

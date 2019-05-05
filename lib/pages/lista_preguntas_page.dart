import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:test_examen/components/drawer.dart';
import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:flutter/material.dart';
import 'package:test_examen/pages/pregunta_page.dart';
import 'package:test_examen/services/authentication.dart';

class ListaPreguntasPage extends StatefulWidget {
  ListaPreguntasPage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ListaPreguntasPageState();
}

class _ListaPreguntasPageState extends State<ListaPreguntasPage> {
  List<Pregunta> _preguntas = List();
  DatabaseReference _listaPreguntasRef;

  final FirebaseDatabase database = FirebaseDatabase.instance;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  Query _preguntasQuery;

  @override
  void initState() {
    super.initState();

    _preguntas = List();

    _preguntasQuery = _database
        .reference()
        .child("testExamen")
        .child("preguntas")
        .orderByChild("usuarios/u1")
        .equalTo(true);
    _onTodoAddedSubscription =
        _preguntasQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription =
        _preguntasQuery.onChildChanged.listen(_onEntryChanged);

    /*_listaPreguntasRef = database.reference().child("testExamen").child("preguntas");
    //Query queryPreguntas = _listaPreguntasRef.orderByChild("texto").equalTo("ccccc");

    _listaPreguntasRef.onChildAdded.listen(_onEntryAdded);
    _listaPreguntasRef.onChildChanged.listen(_onEntryChanged);*/
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  _onEntryAdded(Event event) {
    setState(() {
      _preguntas.add(Pregunta.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = _preguntas.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _preguntas[_preguntas.indexOf(old)] =
          Pregunta.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(g.APPBAR_LISTA_DE_PREGUNTAS)),
      body: _buildBody(context),
      drawer: MyDrawer(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _preguntas.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              _preguntas[index].texto,
              style: TextStyle(fontSize: 20.0),
            ),
            subtitle: _preguntas[index].respuestas != null
                ? Text(_preguntas[index].respuestas[0] +
                    ", " +
                    _preguntas[index].respuestas[1] +
                    ", " +
                    _preguntas[index].respuestas[2])
                : Text(''),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PreguntaPage(
                        pregunta: _preguntas[index],
                        auth: widget.auth,
                        userId: widget.userId,
                        onSignedOut: widget.onSignedOut))),
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
}

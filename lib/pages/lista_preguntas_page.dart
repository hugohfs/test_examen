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
  List<Pregunta> _preguntasUsuario = List();
  List<Pregunta> _preguntasGratis = List();
  List<Tema> _temas = List();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onPreguntaAddedSubscription;
  StreamSubscription<Event> _onPreguntaChangedSubscription;
  StreamSubscription<Event> _onPreguntaGratisAddedSubscription;
  StreamSubscription<Event> _onPreguntaGratisChangedSubscription;
  StreamSubscription<Event> _onTemaAddedSubscription;
  StreamSubscription<Event> _onTemaChangedSubscription;

  Query _preguntasQuery;
  Query _preguntasGratisQuery;
  Query _temarioQuery;


  @override
  void initState() {
    super.initState();

    _preguntas = List();
    _preguntasUsuario = List();
    _preguntasGratis = List();
    _temas = List();

    _preguntasQuery = _database
        .reference()
        .child("testExamen/preguntas");

    _preguntasGratisQuery = _database
        .reference()
        .child("testExamen/preguntasGratis");

    _temarioQuery= _database
        .reference()
        .child("testExamen/temario");

    /*_onPreguntaAddedSubscription =
        _preguntasQuery.onChildAdded.listen(_onPreguntaEntryAdded);
    _onPreguntaChangedSubscription =
        _preguntasQuery.onChildChanged.listen(_onPreguntaEntryChanged);*/

    _onPreguntaGratisAddedSubscription =
        _preguntasGratisQuery.onChildAdded.listen(_onPreguntaGratisEntryAdded);
    _onPreguntaGratisChangedSubscription =
        _preguntasGratisQuery.onChildChanged.listen(_onPreguntaGratisEntryChanged);

    _onTemaAddedSubscription =
        _temarioQuery.onChildAdded.listen(_onTemaEntryAdded);
    _onTemaChangedSubscription =
        _temarioQuery.onChildChanged.listen(_onTemaEntryChanged);

    /*_database.reference().child("testExamen/temario").once().then((DataSnapshot snapshot) {
      Map<dynamic,dynamic> map = snapshot.value;
      map.forEach((key, value) {
        print('$key: $value');

      });
    });*/

  }

  @override
  void dispose() {
    _onPreguntaAddedSubscription.cancel();
    _onPreguntaChangedSubscription.cancel();
    _onPreguntaGratisAddedSubscription.cancel();
    _onPreguntaGratisChangedSubscription.cancel();
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

    Pregunta p = Pregunta.fromSnapshot(event.snapshot);
    setState(() {
      _preguntas[_preguntas.indexOf(old)] = p;
    });
  }

  _onPreguntaGratisEntryAdded(Event event) {
    setState(() {
      Pregunta p = Pregunta.fromSnapshot(event.snapshot);
      _preguntasGratis.add(p);
      _preguntasUsuario.add(p);
    });
  }

  _onPreguntaGratisEntryChanged(Event event) {
    var old = _preguntasGratis.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    Pregunta p = Pregunta.fromSnapshot(event.snapshot);
    setState(() {
      _preguntasGratis[_preguntasGratis.indexOf(old)] = p;
    });
  }

  _onTemaEntryAdded(Event event) {
    Tema t = Tema.fromSnapshot(event.snapshot);
    setState(() {
      _temas.add(t);
    });

    for (String usuario in t.usuarios) {
      if(usuario == g.userInfoDetails.uid) {
        for (String pregunta in t.preguntas) {
          _database.reference().child("testExamen/preguntas/" + pregunta).once().then((DataSnapshot snapshot) {
            Pregunta p = Pregunta.fromSnapshot(snapshot);
            if(!_preguntasUsuario.contains(p)) {
              setState(() {
                _preguntasUsuario.add(p);
              });
            }
          });
        }
        break;
      }
    }

  }

  _onTemaEntryChanged(Event event) {
    var old = _temas.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _temas[_temas.indexOf(old)] = Tema.fromSnapshot(event.snapshot);
    });
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _preguntasUsuario.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              _preguntasUsuario[index].texto ?? '',
              style: TextStyle(fontSize: 20.0),
            ),
            subtitle: _preguntasUsuario[index].respuestas != null
                ? Text(_preguntasUsuario[index].respuestas[0] +
                    ", " +
                  _preguntasUsuario[index].respuestas[1] +
                    ", " +
                  _preguntasUsuario[index].respuestas[2] )
                : Text(''),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PreguntaPage(
                        pregunta: _preguntasUsuario[index],
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(g.APPBAR_LISTA_DE_PREGUNTAS)),
      body: _buildBody(context),
      drawer: new MyDrawer(
          auth: widget.auth,
          userId: widget.userId,
          onSignedOut: widget.onSignedOut),
    );
  }
}

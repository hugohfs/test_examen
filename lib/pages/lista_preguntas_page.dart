import 'package:firebase_database/firebase_database.dart';
import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:test_examen/pages/pregunta_page.dart';

class ListaPreguntasPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ListaPreguntasPageState();
}

class _ListaPreguntasPageState extends State<ListaPreguntasPage> {
  List<Pregunta> _preguntas = List();
  //Pregunta _pregunta = Pregunta('', ['', '', ''], -1);
  DatabaseReference _listaPreguntasRef;

  final FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    //_pregunta = Pregunta('',List<String>(),-1);
    _listaPreguntasRef = database.reference().child("preguntas");

    _listaPreguntasRef.onChildAdded.listen(_onEntryAdded);
    _listaPreguntasRef.onChildChanged.listen(_onEntryChanged);
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
      _preguntas[_preguntas.indexOf(old)] = Pregunta.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text(globals.APPBAR_LISTA_DE_PREGUNTAS)),
        body: _buildBody(context));
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
                    builder: (context) =>
                        PreguntaPage(pregunta: _preguntas[index]))),
            trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.grey, size: 20.0),
                onPressed: () {
                  eliminarPregunta(index);
                }),
          );
        });
  }

  eliminarPregunta(int index) {
    String key = _preguntas[index].key;
    _listaPreguntasRef.child(key).remove().then((_) {
      print("Delete $key successful");
      setState(() {
        _preguntas.removeAt(index);
      });
    });
  }
}

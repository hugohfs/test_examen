// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold] and the [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:test_examen/components/drawer.dart';
import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/pages/lista_preguntas_page.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:fluttertoast/fluttertoast.dart';

class AnadirPreguntaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AnadirPreguntaPageState();
}

class _AnadirPreguntaPageState extends State<AnadirPreguntaPage> {
  List<Pregunta> _preguntas = List();
  Pregunta _pregunta = Pregunta('', ['', '', ''], -1);
  Pregunta _preguntaAnadida;
  DatabaseReference _preguntaRef;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final keyScaffoldState = new GlobalKey<ScaffoldState>();

  String userAccountName = "test.email@gmail.com";
  String userAccountEmail = "test.email@gmail.com";

  int _radioValue = 0;

  @override
  void initState() {
    super.initState();
    _pregunta = Pregunta('', List<String>(), -1);
    _preguntaRef = database.reference().child("preguntas");

    _preguntaRef.onChildAdded.listen(_onEntryAdded);
    _preguntaRef.onChildChanged.listen(_onEntryChanged);
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

  void _handleSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      if (_radioValue < 0) {
        //TODO:
        print('Debe seleccionar una opcion');
      } else {
        form.save();
        form.reset();
        form.reset();
        _preguntaRef.push().set(_pregunta.toJson());

        setState(() {
          _preguntaAnadida = _pregunta;
          _pregunta = Pregunta('', List<String>(), -1);
          _radioValue = -1;
        });

        Fluttertoast.showToast(
          msg: g.TOAST_PREGUNTA_ANADIDA,
          toastLength: Toast.LENGTH_SHORT,
        );

      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: keyScaffoldState,
        appBar: AppBar(
          title: Text(g.APPBAR_ANADIR_PREGUNTAS),
        ),
        drawer: MyDrawer(),
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 0,
              child: Center(
                child: Form(
                  key: formKey,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.title),
                        title: TextFormField(
                          initialValue: "",
                          onSaved: (val) => _pregunta.texto = val,
                          validator: (val) => val == "" ? val : null,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.description),
                        title: TextFormField(
                          initialValue: "",
                          onSaved: (val) => _pregunta.respuestas.add(val),
                          validator: (val) => val == "" ? val : null,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.description),
                        title: TextFormField(
                          initialValue: "",
                          onSaved: (val) => _pregunta.respuestas.add(val),
                          validator: (val) => val == "" ? val : null,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.description),
                        title: TextFormField(
                          initialValue: "",
                          onSaved: (val) => _pregunta.respuestas.add(val),
                          validator: (val) => val == "" ? val : null,
                        ),
                      ),
                      ListTile(
                          leading: Icon(Icons.check),
                          title: Row(
                            children: <Widget>[
                              Text('Op1'),
                              Radio(
                                value: 1,
                                groupValue: _radioValue,
                                onChanged: (val) {
                                  _handleRadioValueChange(val);
                                },
                              ),
                              Text('Op2'),
                              Radio(
                                value: 2,
                                groupValue: _radioValue,
                                onChanged: (val) {
                                  _handleRadioValueChange(val);
                                },
                              ),
                              Text('Op3'),
                              Radio(
                                value: 3,
                                groupValue: _radioValue,
                                onChanged: (val) {
                                  _handleRadioValueChange(val);
                                },
                              )
                            ],
                          )),
                      RaisedButton(
                        //padding: new EdgeInsets.all(0.0),
                        elevation: 5.0,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.blue,
                        child: Text("Añadir pregunta",
                            style: new TextStyle(
                                fontSize: 20.0, color: Colors.white)),
                        onPressed: () {
                          _handleSubmit();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: _preguntaAnadida != null
                  ? ListTile(
                title: Text(
                  _preguntaAnadida.texto,
                  style: TextStyle(fontSize: 20.0),
                ),
                subtitle: (_preguntaAnadida.respuestas != null &&
                    _preguntaAnadida.respuestas.isNotEmpty)
                    ? Text(_preguntaAnadida.respuestas[0] +
                    ", " +
                    _preguntaAnadida.respuestas[1] +
                    ", " +
                    _preguntaAnadida.respuestas[2])
                    : Text(''),
              )
                  : Text(''),
            )
          ],
        ));
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      _pregunta.respuestaCorrecta = _radioValue;
    });
  }
}
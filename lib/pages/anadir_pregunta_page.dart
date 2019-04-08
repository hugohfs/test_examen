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
import 'package:test_examen/model/test_examen.dart';
import 'package:test_examen/model/usuario.dart';
import 'package:test_examen/model/usuario_pregunta.dart';
import 'package:test_examen/pages/lista_preguntas_page.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:fluttertoast/fluttertoast.dart';

class AnadirPreguntaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AnadirPreguntaPageState();
}

class _AnadirPreguntaPageState extends State<AnadirPreguntaPage> {
  List<Pregunta> _preguntas = List();
  Pregunta _pregunta = Pregunta('', ['', '', ''], -1,'');
  TestExamen _testExamen; // = TestExamen(new List<Usuario>(), new List<Pregunta>(), new List<UsuarioPregunta>());
  Pregunta _preguntaAnadida;
  DatabaseReference _textExamenRef;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final keyScaffoldState = new GlobalKey<ScaffoldState>();

  int _radioValue = 0;

  @override
  void initState() {
    super.initState();
    _pregunta = Pregunta('', ['', '', ''], -1,'');
    _testExamen = TestExamen(new List<Usuario>(), new List<Pregunta>(), new List<UsuarioPregunta>());
    _textExamenRef = database.reference().child("textExamen");

    _textExamenRef.onChildAdded.listen(_onEntryAdded);
    _textExamenRef.onChildChanged.listen(_onEntryChanged);
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
        //_textExamenRef.push().set(_testExamen.toJson());
        _textExamenRef.child("preguntas").push().set(_pregunta.toJson());

        setState(() {
          _preguntaAnadida = _pregunta;
          _pregunta = Pregunta('', ['', '', ''], -1,'');
          //_testExamen = TestExamen(new List<Usuario>(), new List<Pregunta>(), new List<UsuarioPregunta>());
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
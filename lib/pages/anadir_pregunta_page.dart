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

  Usuario _usuario;
  UsuarioPregunta _usuarioPregunta;
  List<Usuario> _listaUsuarios = List();
  List<Pregunta> _listaPreguntas = List();
  List<UsuarioPregunta> _listaUsuarioPreguntas = List();
  Pregunta _pregunta;
  TestExamen _testExamen; // = TestExamen(new List<Usuario>(), new List<Pregunta>(), new List<UsuarioPregunta>());
  Pregunta _preguntaAnadida;

  DatabaseReference _testExamenRef;
  DatabaseReference _listaPreguntasRef;
  DatabaseReference _listaUsuariosRef;
  DatabaseReference _listaUsuariosPreguntasRef;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final keyScaffoldState = new GlobalKey<ScaffoldState>();

  Query _usuarioQuery;

  int _radioValue = 0;

  @override
  void initState() {
    super.initState();
    _usuario = Usuario(g.userAccountName,g.userAccountEmail);
    _pregunta = Pregunta('', [], -1,'');
    _usuarioPregunta = UsuarioPregunta(_usuario, _pregunta);
    _testExamen = TestExamen(new List<Usuario>(), new List<Pregunta>(), new List<UsuarioPregunta>());

    _listaPreguntasRef = database.reference().child("testExamen").child("preguntas");
    _listaUsuariosRef = database.reference().child("testExamen").child("usuarios");
    _listaUsuariosPreguntasRef = database.reference().child("testExamen").child("usuariosPreguntas");

    _listaPreguntasRef.onChildAdded.listen(_onEntryAddedPregunta);
    _listaPreguntasRef.onChildChanged.listen(_onEntryChangedPregunta);
    _listaUsuariosRef.onChildAdded.listen(_onEntryAddedUsuario);
    _listaUsuariosRef.onChildChanged.listen(_onEntryChangedUsuario);
    _listaUsuariosPreguntasRef.onChildAdded.listen(_onEntryAddedUsuarioPregunta);
    _listaUsuariosPreguntasRef.onChildChanged.listen(_onEntryChangedUsuarioPregunta);

    /*_testExamenRef = database.reference().child("textExamen");

    _testExamenRef.onChildAdded.listen(_onEntryAdded);
    _testExamenRef.onChildChanged.listen(_onEntryChanged);*/
  }

  _onEntryAddedPregunta(Event event) {
    setState(() {
      _listaPreguntas.add(Pregunta.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChangedPregunta(Event event) {
    var old = _listaPreguntas.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _listaPreguntas[_listaPreguntas.indexOf(old)] =
          Pregunta.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAddedUsuario(Event event) {
    setState(() {
      Usuario ususarioEvent = Usuario.fromSnapshot(event.snapshot);
      bool existe = false;
      _listaUsuarios.forEach((u) {
        if (u.nombre == ususarioEvent.nombre) {
          existe = true;
        }
      });
      if (!existe) {
        _listaUsuarios.add(Usuario.fromSnapshot(event.snapshot));
      } else {
        print('El usuario ya existe.');
      }

    });
  }

  _onEntryChangedUsuario(Event event) {
    var old = _listaUsuarios.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _listaUsuarios[_listaUsuarios.indexOf(old)] =
          Usuario.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAddedUsuarioPregunta(Event event) {
    setState(() {
      _listaUsuarioPreguntas.add(UsuarioPregunta.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChangedUsuarioPregunta(Event event) {
    var old = _listaUsuarioPreguntas.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _listaUsuarioPreguntas[_listaUsuarioPreguntas.indexOf(old)] =
          UsuarioPregunta.fromSnapshot(event.snapshot);
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

        setState(() {
          _usuarioPregunta.pregunta = _pregunta;
          _usuarioPregunta.usuario = _usuario;
        });

        _testExamen.usuarios.add(_usuario);
        _testExamen.preguntas.add(_pregunta);
        _testExamen.usuarioPreguntas.add(_usuarioPregunta);

        //_testExamenRef.push().set(_testExamen.toJson());
        _listaUsuariosRef.push().set(_usuario.toJson());
        _listaPreguntasRef.push().set(_pregunta.toJson());
        _listaUsuariosPreguntasRef.push().set(_usuarioPregunta.toJson());

        setState(() {
          _preguntaAnadida = _pregunta;
          _pregunta = Pregunta('', [], -1,'');
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
                        leading: Icon(Icons.question_answer),
                        title: TextFormField(
                          initialValue: "",
                          onSaved: (val) => _pregunta.explicacion = val,
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
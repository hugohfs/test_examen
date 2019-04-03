// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold] and the [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/pregunta_page.dart';
import 'package:test_examen/globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for material.Scaffold',
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
  List<Pregunta> preguntas = List();
  Pregunta _pregunta = Pregunta('',['','',''],-1);
  DatabaseReference preguntaRef;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String userAccountName = "test.email@gmail.com";
  String userAccountEmail = "test.email@gmail.com";

  int _radioValue = 0;

  @override
  void initState() {
    super.initState();
    _pregunta = Pregunta('',List<String>(),-1);
    preguntaRef = database.reference().child("preguntas");

    preguntaRef.onChildAdded.listen(_onEntryAdded);
    preguntaRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      preguntas.add(Pregunta.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = preguntas.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      preguntas[preguntas.indexOf(old)] = Pregunta.fromSnapshot(event.snapshot);
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
        preguntaRef.push().set(_pregunta.toJson());

        setState(() {
          _pregunta = Pregunta('', List<String>(), -1);
          _radioValue = -1;
        });
      }
    }
  }

  eliminarPregunta(int index) {
    String key = preguntas[index].key;
    preguntaRef.child(key).remove().then((_) {
      print("Delete $key successful");
      setState(() {
        preguntas.removeAt(index);
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Preguntas de examen'),
          actions: <Widget>[
            IconButton(
                icon: Icon((Icons.close)),
                onPressed: () => SystemNavigator.pop())
          ],
        ),
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(userAccountName),
                accountEmail: Text(userAccountEmail),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(userAccountEmail.length > 0
                      ? userAccountEmail[0].toUpperCase()
                      : ""),
                ),
              ),
              ListTile(
                title: Text("Close"),
                trailing: Icon(Icons.close),
                onTap: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
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
                      /*ListTile(
                        leading: Icon(Icons.check),
                        title: TextFormField(
                          initialValue: "",
                          onSaved: (val) => _pregunta.respuestaCorrecta = int.parse(val),
                          validator: (val) => val == "" ? val : null,
                        ),
                      ),*/
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
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: preguntas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          preguntas[index].texto,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        subtitle: preguntas[index].respuestas != null ? Text(preguntas[index].respuestas[0] +
                            ", " +
                            preguntas[index].respuestas[1] +
                            ", " +
                            preguntas[index].respuestas[2]) : Text(''),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreguntaPage(pregunta: preguntas[index]))),
                        trailing: IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.grey, size: 20.0),
                            onPressed: () {
                              eliminarPregunta(index);
                            }),
                      );
                    })
                /*return new ListTile(
                      leading: Icon(Icons.info),
                      title: Text(preguntas[index].texto),
                      subtitle: Text(preguntas[index].respuesta01 +
                          " - " +
                          preguntas[index].respuesta02 +
                          " - " +
                          preguntas[index].respuesta03),
                      onLongPress: () {
                        _showDialogDelete(context, preguntas[index].key, index);
                      },
                    );*/
                //}),
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

  _showDialogDelete(BuildContext context, String preguntaId, int index) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Text('¿Quieres eliminar la pregunta?'),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Si'),
                  onPressed: () async {
                    eliminarPregunta(index);
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}

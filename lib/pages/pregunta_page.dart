import 'package:test_examen/components/drawer.dart';
import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:flutter/material.dart';
import 'package:test_examen/services/authentication.dart';

class PreguntaPage extends StatefulWidget {
  PreguntaPage(
      {Key key, this.pregunta, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  final Pregunta pregunta;
  @override
  State<StatefulWidget> createState() => new _PreguntaPageState();
}

class _PreguntaPageState extends State<PreguntaPage> {
  final _textEditingController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int _radioValue = 0;
  bool _correcta = false;
  bool _comprobar = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Pregunta')),
      body: _buildBody(context),
      drawer:  new MyDrawer(
          auth: widget.auth,
          userId: widget.userId,
          onSignedOut: widget.onSignedOut),
    );
  }

  Widget _buildBody(BuildContext context) {
    return /*Column(children: <Widget>[*/
        Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(widget.pregunta.texto,
                      style: new TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                RadioListTile(
                  value: 0,
                  groupValue: _radioValue,
                  title: Text(widget.pregunta.respuestas[0],
                      style: new TextStyle(fontSize: 20.0)),
                  onChanged: (val) {
                    _handleRadioValueChange(val);
                  },
                ),
                RadioListTile(
                  value: 1,
                  groupValue: _radioValue,
                  title: Text(widget.pregunta.respuestas[1],
                      style: new TextStyle(fontSize: 20.0)),
                  onChanged: (val) {
                    _handleRadioValueChange(val);
                  },
                ),
                RadioListTile(
                  value: 2,
                  groupValue: _radioValue,
                  title: Text(widget.pregunta.respuestas[2],
                      style: new TextStyle(fontSize: 20.0)),
                  onChanged: (val) {
                    _handleRadioValueChange(val);
                  },
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                    child: Wrap(children: <Widget>[
                      RaisedButton(
                        //padding: new EdgeInsets.all(0.0),
                        elevation: 5.0,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.blue,
                        child: Text("Comprobar",
                            style: new TextStyle(
                                fontSize: 20.0, color: Colors.white)),
                        onPressed: () {
                          _handleSubmit(_radioValue);
                        },
                      )
                    ])),
                _showResult()
              ],
            ))
        /*])*/;
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  void _handleSubmit(int radioValue) {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
    }

    setState(() {
      _comprobar = true;
    });

    if (widget.pregunta.respuestaCorrecta == (radioValue + 1)) {
      setState(() {
        _correcta = true;
      });
    } else {
      setState(() {
        _correcta = false;
      });
    }
  }

  Widget _showResult() {
    if (_comprobar) {
      if (_correcta) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: new ListBody(children: <Widget>[
              ListTile(
                title: Text(g.RESPUESTA_CORRECTA,
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ),
              ListTile(
                  title: Wrap(
                children: <Widget>[
                  Text(
                    'Explicación: ',
                    style: new TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.pregunta.explicacion,
                      style: new TextStyle(fontSize: 18.0)),
                ],
              ))
            ]));
      } else {
        return Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
            child: ListTile(
              title: Text(g.RESPUESTA_INCORRECTA,
                  style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
            ));
      }
    } else {
      return Text('');
    }
  }
}

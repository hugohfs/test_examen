import 'package:test_examen/components/drawer.dart';
import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/globals/globals.dart' as g;
import 'package:flutter/material.dart';

class PreguntaPage extends StatefulWidget {
  PreguntaPage({Key key, this.pregunta}) : super(key: key);

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
        drawer: MyDrawer(),
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
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
              ),
              RadioListTile(
                value: 0,
                groupValue: _radioValue,
                title: Text(widget.pregunta.respuestas[0]),
                //subtitle: Text("Radio 1 Subtitle"),
                onChanged: (val) {
                  _handleRadioValueChange(val);
                },
              ),
              RadioListTile(
                value: 1,
                groupValue: _radioValue,
                title: Text(widget.pregunta.respuestas[1]),
                //subtitle: Text("Radio 1 Subtitle"),
                onChanged: (val) {
                  _handleRadioValueChange(val);
                },
              ),
              RadioListTile(
                value: 2,
                groupValue: _radioValue,
                title: Text(widget.pregunta.respuestas[2]),
                //subtitle: Text("Radio 1 Subtitle"),
                onChanged: (val) {
                  _handleRadioValueChange(val);
                },
              ),
              Wrap(children: <Widget>[
                RaisedButton(
                  //padding: new EdgeInsets.all(0.0),
                  elevation: 5.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  child: Text("Comprobar",
                      style:
                          new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: () {
                    _handleSubmit(_radioValue);
                  },
                )
              ]),
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
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new Text(
              g.RESPUESTA_CORRECTA,
              style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.green,
                  height: 1.0,
                  fontWeight: FontWeight.w400),
            ));
      } else {
        return Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new Text(
              g.RESPUESTA_INCORRECTA,
              style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.red,
                  height: 1.0,
                  fontWeight: FontWeight.w400),
            ));
      }
    } else {
      return Text('');
    }

  }
}

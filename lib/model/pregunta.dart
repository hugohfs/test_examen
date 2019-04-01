import 'package:firebase_database/firebase_database.dart';

class Pregunta {
  String key;
  String texto;
  String respuesta01;
  String respuesta02;
  String respuesta03;

  Pregunta(this.texto, this.respuesta01, this.respuesta02, this.respuesta03);

  Pregunta.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        texto = snapshot.value["texto"],
        respuesta01 = snapshot.value["respuesta01"],
        respuesta02 = snapshot.value["respuesta02"],
        respuesta03 = snapshot.value["respuesta03"];

  toJson() {
    return {
      "texto": texto,
      "respuesta01": respuesta01,
      "respuesta02": respuesta02,
      "respuesta03": respuesta03
    };
  }
}

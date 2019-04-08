import 'package:firebase_database/firebase_database.dart';

class Pregunta {
  String key;
  String texto;
  List<String> respuestas;
  int respuestaCorrecta;
  String explicacion;

  Pregunta(
      this.texto, this.respuestas, this.respuestaCorrecta, this.explicacion);

  Pregunta.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        texto =
            snapshot.value["texto"] != null ? snapshot.value["texto"] : null,
        respuestas = snapshot.value["respuestas"] != null
            ? snapshot.value["respuestas"].cast<String>()
            : null,
        respuestaCorrecta = snapshot.value["respuestaCorrecta"] != null
            ? snapshot.value["respuestaCorrecta"]
            : null,
        explicacion = snapshot.value["explicacion"] != null
            ? snapshot.value["explicacion"]
            : null;

  toJson() {
    return {
      "texto": texto,
      "respuestas": respuestas,
      "respuestaCorrecta": respuestaCorrecta,
      "explicacion": explicacion
    };
  }

  Pregunta.fromJson(Map json){
    this.key = json["key"];
    this.texto = json["texto"];
    this.respuestas = json.containsKey('respuestas')
        ? json['respuestas'].cast<String>()
        : null;
    this.respuestaCorrecta = json["respuestaCorrecta"];
    this.explicacion = json["explicacion"];
  }

}


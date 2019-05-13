import 'package:firebase_database/firebase_database.dart';
import 'package:test_examen/model/usuarios_pregunta.dart';

class Pregunta {
  String key;
  String texto;
  List<String> respuestas;
  int respuestaCorrecta;
  String explicacion;
  List<String> usuariosPregunta;

  Pregunta(
      this.texto, this.respuestas, this.respuestaCorrecta, this.explicacion, this.usuariosPregunta);

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
            : null,
        usuariosPregunta = snapshot.value["usuariosPregunta"] != null
            ? snapshot.value["usuariosPregunta"].cast<String>()
            : null;

  toJson() {
    return {
      "texto": texto,
      "respuestas": respuestas,
      "respuestaCorrecta": respuestaCorrecta,
      "explicacion": explicacion,
      "usuariosPregunta": usuariosPregunta
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
    this.usuariosPregunta = json.containsKey('usuariosPregunta')
        ? json['usuariosPregunta']
        : null;
  }

  @override
  String toString() {
    return 'Pregunta{key: $key, texto: $texto, respuestas: $respuestas, respuestaCorrecta: $respuestaCorrecta, explicacion: $explicacion, usuariosPregunta: $usuariosPregunta}';
  }


}


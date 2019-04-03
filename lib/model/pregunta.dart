import 'package:firebase_database/firebase_database.dart';

class Pregunta {
  String key;
  String texto;
  List<String> respuestas;
  int respuestaCorrecta;

  Pregunta(this.texto, this.respuestas, this.respuestaCorrecta);

  Pregunta.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        texto =
            snapshot.value["texto"] != null ? snapshot.value["texto"] : null,
        respuestas = snapshot.value["respuestas"] != null
            ? snapshot.value["respuestas"].cast<String>()
            : null,
        respuestaCorrecta = snapshot.value["respuestaCorrecta"] != null
            ? snapshot.value["respuestaCorrecta"]
            : null;

  toJson() {
    return {
      "texto": texto,
      "respuestas": respuestas,
      "respuestaCorrecta": respuestaCorrecta
    };
  }
}

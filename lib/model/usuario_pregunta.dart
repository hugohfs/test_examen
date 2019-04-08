import 'package:firebase_database/firebase_database.dart';

class UsuarioPregunta {
  String key;
  //int id;
  String usuariokey;
  String preguntakey;
  String respuestaElegida;
  bool correcta;
  //Rol rol;

  UsuarioPregunta(this.usuariokey, this.preguntakey);

  UsuarioPregunta.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        usuariokey =
        snapshot.value["usuariokey"] != null ? snapshot.value["usuariokey"] : null,
        preguntakey =
        snapshot.value["preguntakey"] != null ? snapshot.value["preguntakey"] : null,
        respuestaElegida =
        snapshot.value["respuestaElegida"] != null ? snapshot.value["respuestaElegida"] : null,
        correcta =
        snapshot.value["correcta"] != null ? snapshot.value["correcta"] : null;

  toJson() {
    return {
      "usuariokey": usuariokey,
      "preguntakey": preguntakey,
      "respuestaElegida" : respuestaElegida,
      "correcta" : correcta
    };
  }
}

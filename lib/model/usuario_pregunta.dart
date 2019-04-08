import 'package:firebase_database/firebase_database.dart';
import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/model/usuario.dart';

class UsuarioPregunta {
  String key;
  //int id;
  Usuario usuario;
  Pregunta pregunta;
  String respuestaElegida;
  bool correcta;
  //Rol rol;

  UsuarioPregunta(this.usuario, this.pregunta);

  UsuarioPregunta.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        usuario =
        snapshot.value["usuario"] != null ? new Usuario.fromJson(snapshot.value["usuario"]) : null,
        pregunta =
        snapshot.value["pregunta"] != null ? new Pregunta.fromJson(snapshot.value["pregunta"]) : null,
        respuestaElegida =
        snapshot.value["respuestaElegida"] != null ? snapshot.value["respuestaElegida"] : null,
        correcta =
        snapshot.value["correcta"] != null ? snapshot.value["correcta"] : null;

  toJson() {
    return {
      "usuario": usuario.toJson(),
      "pregunta": pregunta.toJson(),
      "respuestaElegida" : respuestaElegida,
      "correcta" : correcta
    };
  }
}

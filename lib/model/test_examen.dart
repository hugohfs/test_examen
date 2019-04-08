import 'package:firebase_database/firebase_database.dart';
import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/model/usuario.dart';
import 'package:test_examen/model/usuario_pregunta.dart';

class TestExamen {
  String key;
  //int id;
  List<Usuario> usuarios;
  List<Pregunta> preguntas;
  List<UsuarioPregunta> usuarioPreguntas;

  TestExamen(this.usuarios, this.preguntas, this.usuarioPreguntas);

  TestExamen.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        usuarios =
        snapshot.value["usuarios"] != null ? snapshot.value["usuarios"] : null,
        preguntas =
        snapshot.value["preguntas"] != null ? snapshot.value["preguntas"] : null,
        usuarioPreguntas =
        snapshot.value["usuarioPreguntas"] != null ? snapshot.value["usuarioPreguntas"] : null;

  toJson() {
    return {
      "usuarios": usuarios,
      "preguntas": preguntas,
      "usuarioPreguntas" : usuarioPreguntas
    };
  }
}

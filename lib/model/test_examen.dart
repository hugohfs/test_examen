import 'package:firebase_database/firebase_database.dart';
import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/model/temario.dart';
import 'package:test_examen/model/usuario.dart';

class TestExamen {
  String key;
  //int id;
  List<Usuario> usuarios;
  List<Pregunta> preguntas;
  List<Tema> temario;


  TestExamen(this.usuarios, this.preguntas, this.temario);

  TestExamen.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        usuarios =
        snapshot.value["usuarios"] != null ? snapshot.value["usuarios"] : null,
        preguntas =
        snapshot.value["preguntas"] != null ? snapshot.value["preguntas"] : null,
        temario =
        snapshot.value["temario"] != null ? snapshot.value["temario"] : null;

  toJson() {
    return {
      "usuarios": usuarios,
      "preguntas": preguntas,
      "temario" : temario
    };
  }
}

import 'package:firebase_database/firebase_database.dart';

class UsuariosPregunta {
  String key;
  List<bool> usuarios;

  UsuariosPregunta(this.usuarios);

  UsuariosPregunta.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        usuarios =
        snapshot.value["usuarios"] != null ? snapshot.value["usuarios"] : null;

  toJson() {
    return {
      "usuarios": usuarios
    };
  }
}

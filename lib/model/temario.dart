import 'package:firebase_database/firebase_database.dart';

class Tema {
  String key;
  String nombre;
  List<String> preguntas;
  List<String> usuarios;

  //Rol rol;

  Tema(this.nombre, this.preguntas, this.usuarios);

  Tema.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        nombre =
        snapshot.value["nombre"] != null ? snapshot.value["nombre"] : null,
        preguntas =
        snapshot.value["preguntas"] != null ? snapshot.value["preguntas"].cast<String>() : null,
        usuarios =
        snapshot.value["usuarios"] != null ? List.from(snapshot.value["usuarios"].cast<String>()) : null;
        //snapshot.value["usuarios"] != null ? snapshot.value["usuarios"].cast<String>() : null;

  toJson() {
    return {
      "nombre": nombre,
      "preguntas": preguntas,
      "usuarios": usuarios
    };
  }

  Tema.fromJson(Map json){
    this.nombre = json.containsKey('nombre') == true
        ? json['nombre']
        : null;
    this.preguntas = json.containsKey('preguntas') == true
        ? json['preguntas'].cast<String>()
        : null;
    this.usuarios = json.containsKey('usuarios') == true
        ? json['usuarios'].cast<String>()
        : null;
  }

  @override
  String toString() {
    return 'Tema{key: $key, nombre: $nombre, preguntas: $preguntas, usuarios: $usuarios}';
  }


}

import 'package:firebase_database/firebase_database.dart';

class Tema {
  String key;
  String nombre;
  List<String> preguntas;

  //Rol rol;

  Tema(this.nombre, this.preguntas);

  Tema.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        nombre =
        snapshot.value["nombre"] != null ? snapshot.value["nombre"] : null,
        /*preguntas =
        snapshot.value["preguntas"] != null ? snapshot.value["preguntas"] : null,*/
        preguntas =
        snapshot.value["preguntas"] != null ? snapshot.value["preguntas"].cast<String>() : null;

  toJson() {
    return {
      "nombre": nombre,
      "preguntas": preguntas
    };
  }

  Tema.fromJson(Map json){
    this.nombre = json.containsKey('nombre') == true
        ? json['nombre']
        : null;
    this.preguntas = json.containsKey('preguntas') == true
        ? json['preguntas'].cast<String>()
        : null;
  }

}

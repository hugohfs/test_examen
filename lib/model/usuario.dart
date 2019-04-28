import 'package:firebase_database/firebase_database.dart';

class Usuario {
  String key;
  String nombre;
  String correo;
  List<String> temas;

  //Rol rol;

  Usuario(this.nombre, this.correo, this.temas);

  Usuario.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        nombre =
        snapshot.value["nombre"] != null ? snapshot.value["nombre"] : null,
        correo =
        snapshot.value["correo"] != null ? snapshot.value["correo"] : null,
        temas =
        snapshot.value["temas"] != null ? snapshot.value["temas"] : null;

  toJson() {
    return {
      "nombre": nombre,
      "correo": correo,
      "temas": temas
    };
  }

  Usuario.fromJson(Map json){
    this.nombre = json.containsKey('temas') == true
        ? json["nombre"]
        : null;
    this.correo = json.containsKey('temas') == true
        ? json["correo"]
        : null;
    this.temas = json.containsKey('temas') == true
        ? json['temas'].cast<String>()
        : null;
  }

}

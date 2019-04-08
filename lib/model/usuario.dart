import 'package:firebase_database/firebase_database.dart';

class Usuario {
  String key;
  //int id;
  String nombre;
  String correo;
  //Rol rol;

  Usuario(this.nombre, this.correo);

  Usuario.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        nombre =
        snapshot.value["nombre"] != null ? snapshot.value["nombre"] : null,
        correo =
        snapshot.value["correo"] != null ? snapshot.value["correo"] : null;

  toJson() {
    return {
      "nombre": nombre,
      "correo": correo
    };
  }

  Usuario.fromJson(Map map){
    this.nombre = map["nombre"];
    this.correo = map["correo"];
  }

}

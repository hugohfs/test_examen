library test_examen.globals;

import 'package:test_examen/model/pregunta.dart';
import 'package:test_examen/model/user_info_details.dart';

UserInfoDetails userInfoDetails = new UserInfoDetails('', '', '', '', '');
/*String userAccountName = 'usuario1';
String userAccountEmail = 'usuario1.examen@gmail.com';
String photoUrl = 'usuario1.examen@gmail.com';*/
//Pregunta pregunta = Pregunta('',List<String>(),-1,'');

bool isEmailVerified = false;


/*main.dart*/
final String APPBAR_MENU_PRINCIPAL = 'Test de examen';
final String DRAWER_HOME = 'Home';
final String DRAWER_ANADIR_PREGUNTAS = 'Añadir preguntas';
final String DRAWER_LISTA_DE_PREGUNTAS = 'Lista de preguntas';

/*anadir_pregunta_page.dart*/
final String TOAST_PREGUNTA_ANADIDA = 'Pregunta añadida correctamente.';

/*lista_preguntas_page.dart*/
final String APPBAR_LISTA_DE_PREGUNTAS = 'Lista de preguntas';
final String APPBAR_ANADIR_PREGUNTAS = 'Añadir preguntas';

/*pregunta_page.dart*/
final String RESPUESTA_CORRECTA = 'Respuesta correcta.';
final String RESPUESTA_INCORRECTA = 'Respuesta incorrecta.';

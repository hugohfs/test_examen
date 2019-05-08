library test_examen.globals;

import 'package:test_examen/model/user_info_details.dart';

UserInfoDetails userInfoDetails = new UserInfoDetails('', '', '', '', '');
/*String userAccountName = 'usuario1';
String userAccountEmail = 'usuario1.examen@gmail.com';
String photoUrl = 'usuario1.examen@gmail.com';*/
//Pregunta pregunta = Pregunta('',List<String>(),-1,'');

bool isEmailVerified = false;

/*login_signup_page.dart*/
final String CORREO = 'Correo';
final String CONTRASENYA = 'Contraseña';
final String URL_LOGO_POR_DEFECTO = 'https://lh3.googleusercontent.com/-Hz_AWw7pDnE/XNBsJYnSJ-I/AAAAAAAAAAs/0e1IBzYaqKE9UIrl6c0fdF-Ph8OeZiKUACEwYBhgL/w140-h140-p/flutter-logo-round.png';
final String INICIAR_SESION_CORREO = 'Iniciar sesión con correo';
final String CREAR_CUENTA_CORREO = 'Crear una cuenta con correo';
final String TIENES_CUENTA_INICIA_SESION = 'Tienes una cuenta? Inicia sesión';
final String CORREO_VACIO = 'El correo no puede estar vacío';
final String CONTRASENYA_VACIA = 'La contraseña no puede estar vacía';
final String ENLACE_VERIFICAR_CUENTA = 'Se ha enviado un enlace a tu correo para verificar la cuenta';
final String INICIAR_SESION_GOOGLE = 'Iniciar sesión con Google';

/*main.dart*/
final String APPBAR_MENU_PRINCIPAL = 'Test de examen';
final String DRAWER_INICIO = 'Inicio';
final String DRAWER_ANADIR_PREGUNTAS = 'Añadir preguntas';
final String DRAWER_LISTA_DE_PREGUNTAS = 'Lista de preguntas';
final String DRAWER_CERRAR = 'Cerrar';
final String DRAWER_CERRAR_SESISON = 'Cerrar sesión';
final String DRAWER_SALIR = 'Salir';

/*anadir_pregunta_page.dart*/
final String TOAST_PREGUNTA_ANADIDA = 'Pregunta añadida correctamente.';

/*lista_preguntas_page.dart*/
final String APPBAR_LISTA_DE_PREGUNTAS = 'Lista de preguntas';
final String APPBAR_ANADIR_PREGUNTAS = 'Añadir preguntas';

/*pregunta_page.dart*/
final String RESPUESTA_CORRECTA = 'Respuesta correcta.';
final String RESPUESTA_INCORRECTA = 'Respuesta incorrecta.';

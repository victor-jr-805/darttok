// config/theme/app_colors.dart

import 'package:flutter/material.dart';

// Colores funcionales: su significado es fijo y no debe depender del
// seedColor de AppTheme, aunque cambiemos la identidad visual de la app.
class AppColors {
  // Convención universal para "me gusta" — un corazón de otro color
  // no se leería igual, sin importar la marca de la app.
  static const like = Colors.red;

  // Blanco fijo para iconos sobre video. El fondo de cada video es
  // impredecible (puede ser muy claro o muy oscuro), así que un color
  // de icono ligado al tema no garantizaría contraste en todos los casos.
  static const videoIcon = Colors.white;
}

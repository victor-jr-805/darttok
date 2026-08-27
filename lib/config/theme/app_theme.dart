// config/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Color semilla: toda la paleta de la app se deriva de este
  // univo valor.
  // Un rosa/magenta evoca el mundo de apps de video corto sin
  // copiar ninguna marca actual.
  static const _seedColor = Color(0xFFE91E63);

  ThemeData theme() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ).copyWith(
          // Material 3 generaria una superficie gris oscurocon
          // un ligero tinte del seedColor. La forzamos a negro
          // puro para un fondo tipo TikTok, sin perder el resto
          // de la paleta derivada.
          surface: Colors.black,
        );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
    );
  }
}

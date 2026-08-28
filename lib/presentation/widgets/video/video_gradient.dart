// presentation/widgets/video/video_gradient.dart

import 'package:flutter/material.dart';

// Gradiente oscuro sobre la parte inferioir del video, para que el
// captain siga siendo legible incluso si el video de fondo es muy claro.
class VideoGradient extends StatelessWidget {
  final List<Color> colors;
  final List<double> stops;

  const VideoGradient({
    super.key,
    this.colors = const [Colors.transparent, Colors.black87],
    this.stops = const [0.0, 1.0],
  }) : assert(
         colors.length == stops.length,
         'La cantidad de colores debe ser igual a la cantidad de stops',
       );

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            stops: stops,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}

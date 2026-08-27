// presentation/widgets/shared/video_scrollable_view.dart

import 'package:darttok/domain/entities/video_post.dart';
import 'package:flutter/material.dart';

class VideoScrollableView extends StatelessWidget {
  final List<VideoPost> videos;

  // Callback sin argumentos: este widget no sabe nada de paginacion,
  // paginas ni providers. Solo avisa "estoy cerca del final" y quien
  // lo use decide que hacer con eso.
  final VoidCallback onNearEnd;

  const VideoScrollableView({
    super.key,
    required this.videos,
    required this.onNearEnd,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: videos.length,
      onPageChanged: (index) {
        // Umbral: cuando falten 3 o menos videos para el final de la
        // lista actual, avisamos. Puede dispararse varias veces seguidas
        // mientras el usuario sigue dentro del umbral — no hay problema,
        // el provider ya se protege contra peticiones duplicadas.
        if (index >= videos.length - 3) {
          onNearEnd();
        }
      },
      itemBuilder: (context, index) {
        final video = videos[index];

        // TEMPORAL: contenedor de color solido con el caption encima.
        // Se reemplaza por el reproductor real en el Modulo 12.
        return Container(
          color: Colors.primaries[video.id % Colors.primaries.length],
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(24),
          child: Text(video.caption,
          style: const TextStyle(color: Colors.white, fontSize: 18),),
        );
      },
    );
  }
}

// presentation/widgets/shared/video_scrollable_view.dart

import 'package:darttok/domain/entities/video_post.dart';
import 'package:darttok/presentation/widgets/video/fullscreen_player.dart';
import 'package:flutter/material.dart';

class VideoScrollableView extends StatefulWidget {
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
  State<VideoScrollableView> createState() => _VideoScrollableViewState();
}

class _VideoScrollableViewState extends State<VideoScrollableView> {
  // Índice del video que se está viendo ahora mismo. Cada
  // FullscreenPlayer compara este valor contra su propio índice para
  // saber si debe reproducirse o pausarse.
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.videos.length,
      onPageChanged: (index) {
        setState(() => _currentPage = index);

        // Umbral: cuando falten 3 o menos videos para el final de la
        // lista actual, avisamos. Puede dispararse varias veces seguidas
        // mientras el usuario sigue dentro del umbral — no hay problema,
        // el provider ya se protege contra peticiones duplicadas.
        if (index >= widget.videos.length - 3) {
          widget.onNearEnd();
        }
      },
      itemBuilder: (context, index) {
        final video = widget.videos[index];

        return FullscreenPlayer(
          videoUrl: video.videoUrl,
          caption: video.caption,
          isCurrentVideo: index == _currentPage,
        );
      },
    );
  }
}

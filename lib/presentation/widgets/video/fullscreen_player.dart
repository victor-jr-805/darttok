import 'package:darttok/presentation/widgets/video/video_gradient.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullscreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;

  // Le dice a este widget si es el video que el usuario esta viendo
  // ahora mismo en el PageView. Lo decide el padre (VideoScrollableView)
  // no este widget.
  final bool isCurrentVideo;

  const FullscreenPlayer({
    super.key,
    required this.videoUrl,
    required this.caption,
    required this.isCurrentVideo,
  });

  @override
  State<FullscreenPlayer> createState() => _FullscreenPlayerState();
}

class _FullscreenPlayerState extends State<FullscreenPlayer> {
  late final VideoPlayerController _controller;
  late final Future<void> _initializeVideoFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..setVolume(0)
      ..setLooping(true);

    // Solo reproducimos automaticamente si, desde el inicio, este ya
    // es el video visible (por ejemplo, el primero de la lista).
    _initializeVideoFuture = _controller.initialize().then((_) {
      if (widget.isCurrentVideo) {
        _controller.play();
      }
    });
  }

  @override
  void didUpdateWidget(covariant FullscreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reacciona cuando este video deja de ser (o vuelve a ser) el
    // video visible, sin recrear el controller ni volver a descargar nada.
    if (oldWidget.isCurrentVideo != widget.isCurrentVideo) {
      if (widget.isCurrentVideo) {
        _controller.play();
        debugPrint('Reproduciendo: ${widget.caption}');
      } else {
        _controller.pause();
        debugPrint('Pausado: ${widget.caption}');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoFuture,
      builder: (context, snapshot) {
        // Ahora sí revisamos si el Future terminó con error, en vez de
        // asumir que "terminado" significa "exitoso".
        if (snapshot.hasError) {
          return const Center(
            child: Icon(Icons.error_outline, color: Colors.white54, size: 40),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        return GestureDetector(
          onTap: _togglePlayPause,
          // StackFit.expand: este Stack SIEMPRE llena todo el espacio
          // que le den, sin importar si el padre le dio constraints
          // sueltas (como ahora, dentro de VideoScrollableView) o
          // ajustadas. Esto elimina el problema de raíz.
          child: Stack(
            fit: StackFit.expand,
            children: [
              // En vez de forzar el tamaño del contenedor a la
              // proporción del video (lo que dejaba franjas negras),
              // le damos al video su tamaño nativo y dejamos que
              // FittedBox lo escale para CUBRIR toda la pantalla,
              // recortando el sobrante.
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
              VideoGradient(stops: [0.8, 1.0]),
              Positioned(
                bottom: 70,
                left: 30,
                child: _VideoCaption(caption: widget.caption),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Texto del caption, limitado al 60% del ancho de pantalla para no
// invadir el espacio de los botones de like/views.
class _VideoCaption extends StatelessWidget {
  final String caption;

  const _VideoCaption({required this.caption});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SizedBox(
      width: size.width * 0.6,
      child: Text(
        caption,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: titleStyle?.copyWith(color: Colors.white),
      ),
    );
  }
}

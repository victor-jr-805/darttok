// presentation/providers/for_you_provider.dart

import 'package:darttok/domain/entities/video_post.dart';
import 'package:darttok/domain/repositories/video_posts_repository.dart';
import 'package:flutter/material.dart';

class ForYouProvider extends ChangeNotifier {
  // El repository llega por constructor (inyeccion de dependencias):
  // este Provider no sabe ni le importa si detras hay Pixabay,
  // datos locales, o un repositorio falso de pruebas.
  final VideoPostsRepository repository;

  ForYouProvider({required this.repository});

  static const _perPage = 20;

  // ESTADO
  bool initialLoading = true;
  bool hasError = false;
  bool isLoadingNextPage = false;
  List<VideoPost> videos = [];

  int _page = 1;
  bool _hasReachedEnd = false;

  // IDs ya cargados, para nunca mostrar el mismo video dos veces aunque
  // Pixabay lo repita en distintas paginas.
  final Set<int> _seenIds = {};

  // Único punto de entrada para cargar videos: sirve para la carga
  // inicial, para pedir "la siguiente página" al hacer scroll, y para
  // reintentar tras un error (en ese caso _page no avanzó, así que
  // reintenta la misma página que falló).
  Future<void> loadNextPage() async {
    // Evita pedir dos veces la misma página si el usuario scrollea
    // rápido, y evita seguir pidiendo una vez que ya no hay más videos.
    if (isLoadingNextPage || _hasReachedEnd) {
      return;
    }

    isLoadingNextPage = true;
    // El spinner de pantalla completa solo se muestra si todavia no hay
    // ningun video visible. Si ya hay contenido, cargar "mas" es invisible.
    if (videos.isEmpty) {
      initialLoading = true;
      hasError = false;
    }
    notifyListeners();

    debugPrint('Cargando pagina $_page...');

    try {
      final newVideos = await repository.getPopularVideos(
        page: _page,
        perPage: _perPage,
      );

      if (newVideos.isEmpty) {
        _hasReachedEnd = true;
      } else {
        final uniqueNewVideos = newVideos
            .where((video) => _seenIds.add(video.id))
            .toList();
        videos = [...videos, ...uniqueNewVideos];
        _page++;
      }
      hasError = false;
    } catch (e) {
      // Si ya teniamos videos en pantalla, un fallo al pedir "mas" no
      // debe borrar lo que ya funcionaba: solo dejamos de intentar.
      if (videos.isEmpty) {
        hasError = true;
      }
    } finally {
      isLoadingNextPage = false;
      initialLoading = false;
      notifyListeners();
    }
  }
}

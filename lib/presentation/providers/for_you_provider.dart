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

  // ESTADO
  bool initialLoading = true;
  bool hasError = false;
  List<VideoPost> videos = [];

  // Carga la primera pagina de videos.
  // La logica de paginacion real (pedir la pagina siguiente al
  // hacer scroll, evita pedir dos veces la misma) se agrega en
  // el Modulo 11. Por ahora, solo carga una vez.
  Future<void> loadNextPage() async {
    // Marcamos el inicio de una carga (ya sea la primera vez o un
    // reintento) y avisamos a la UI de inmediato para mostrar el spinner.
    initialLoading = true;
    hasError = false;
    notifyListeners();

    try {
      videos = await repository.getPopularVideos();
    } catch (e) {
      hasError = true;
    } finally {
      initialLoading = false;
      notifyListeners();
    }
  }
}

// infrastructure/datasources/pixabay_datasource_impl.dart

import 'package:darttok/domain/datasources/video_posts_datasource.dart';
import 'package:darttok/domain/entities/video_post.dart';
import 'package:darttok/domain/errors/video_posts_exception.dart';
import 'package:darttok/infrastructure/models/pixabay_video_model.dart';
import 'package:dio/dio.dart';

class PixabayDatasourceImpl implements VideoPostsDatasource {
  // Cliente HTTP recibido por construccion (inyeccion de dependencias).
  // en vez de crearlo aqui adentro, para poder reemplazarlo por uno
  // falso en los texts de Modulo 14.
  final Dio dio;

  // La API key tampoco se lee aqui directo del entorno: la recibe
  // quien construya esta clase (el Modulo 7 profundiza en esto).
  final String apiKey;

  PixabayDatasourceImpl({required this.dio, required this.apiKey});

  @override
  Future<List<VideoPost>> getPopularVideos({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      // Misma URL y parametros que ya probamos en Bruno.
      final response = await dio.get(
        'https://pixabay.com/api/videos/',
        queryParameters: {'key': apiKey, 'page': page, 'per_page': perPage},
      );

      // "hits" es la lista de videos dentro de la respuesta.
      final List hits = response.data['hits'];

      // JSON crudo >>> Modelo >>> Entidad. en un solo recorrido.
      return hits
          .map((json) => PixabayVideoModel.tryFromJson(json))
          .whereType<PixabayVideoModel>()
          .map((model) => model.toVideoPostEntity())
          .toList();
    } on DioException catch (e) {
      // Convertimos el error especifico de Dio en nuestra excepcion de
      // deminio, para que nadie fuera de esta clase necesite saber que
      // usamos Dio.
      throw VideoPostsException(
        'No se pudieron cargar los videos de Pixabay: ${e.message}',
      );
    }
  }
}

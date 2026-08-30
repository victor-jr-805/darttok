// test/presentation/providers/for_you_provider_test.dart

import 'package:darttok/domain/entities/video_post.dart';
import 'package:darttok/domain/repositories/video_posts_repository.dart';
import 'package:darttok/presentation/providers/for_you_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock generado con mocktail: implementa VideoPostsRepository sin
// tocar Dio, Pixabay, ni ningún dato local real.
class MockVideoPostsRepository extends Mock implements VideoPostsRepository {}

VideoPost _video(int id) => VideoPost(
  id: id,
  caption: 'video $id',
  videoUrl: 'https://cdn.pixabay.com/$id.mp4',
  likes: id * 10,
  views: id * 100,
);

void main() {
  late MockVideoPostsRepository repository;
  late ForYouProvider provider;

  setUp(() {
    repository = MockVideoPostsRepository();
    provider = ForYouProvider(repository: repository);
  });

  group('ForYouProvider.loadNextPage', () {
    test('carga videos exitosamente y actualiza el estado', () async {
      when(
        () => repository.getPopularVideos(
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((_) async => [_video(1), _video(2)]);

      await provider.loadNextPage();

      expect(provider.videos.length, 2);
      expect(provider.initialLoading, isFalse);
      expect(provider.hasError, isFalse);
    });

    test(
      'marca hasError cuando falla y todavía no había videos cargados',
      () async {
        when(
          () => repository.getPopularVideos(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          ),
        ).thenThrow(Exception('sin conexión'));

        await provider.loadNextPage();

        expect(provider.hasError, isTrue);
        expect(provider.videos, isEmpty);
      },
    );

    test(
      'no marca error si ya había videos cargados y una carga posterior falla',
      () async {
        when(
          () => repository.getPopularVideos(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          ),
        ).thenAnswer((_) async => [_video(1)]);
        await provider.loadNextPage(); // primera carga: exitosa

        when(
          () => repository.getPopularVideos(
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          ),
        ).thenThrow(Exception('sin conexión'));
        await provider.loadNextPage(); // segunda carga: falla

        expect(provider.hasError, isFalse);
        expect(provider.videos.length, 1); // conserva lo que ya tenía
      },
    );

    test('evita videos duplicados entre páginas distintas', () async {
      when(
        () => repository.getPopularVideos(
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((_) async => [_video(1), _video(2)]);
      when(
        () => repository.getPopularVideos(
          page: 2,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((_) async => [_video(2), _video(3)]); // id 2 repetido

      await provider.loadNextPage(); // pide página 1
      await provider.loadNextPage(); // pide página 2

      final ids = provider.videos.map((v) => v.id).toList();
      expect(ids, [1, 2, 3]); // el id 2 no se duplica
    });

    test(
      'deja de pedir más páginas cuando la api devuelve una lista vacía',
      () async {
        when(
          () => repository.getPopularVideos(
            page: 1,
            perPage: any(named: 'perPage'),
          ),
        ).thenAnswer((_) async => [_video(1)]);
        when(
          () => repository.getPopularVideos(
            page: 2,
            perPage: any(named: 'perPage'),
          ),
        ).thenAnswer((_) async => []); // ya no hay más videos

        await provider.loadNextPage(); // página 1
        await provider.loadNextPage(); // página 2, vacía -> se acabó
        await provider.loadNextPage(); // no debería pedir página 3

        verify(
          () => repository.getPopularVideos(
            page: 1,
            perPage: any(named: 'perPage'),
          ),
        ).called(1);
        verify(
          () => repository.getPopularVideos(
            page: 2,
            perPage: any(named: 'perPage'),
          ),
        ).called(1);
        verifyNever(
          () => repository.getPopularVideos(
            page: 3,
            perPage: any(named: 'perPage'),
          ),
        );
      },
    );
  });
}

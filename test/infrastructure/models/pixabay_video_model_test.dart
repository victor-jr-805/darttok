// test/infrastructure/models/pixabay_video_model_test.dart
import 'package:darttok/infrastructure/models/pixabay_video_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PixabayVideoModel.tryFromJson', () {
    test('arma el modelo completo cuando el json viene bien formado', () {
      final json = {
        'id': 228847,
        'name': 'waterfall, mountain stream, flow',
        'likes': 5567,
        'views': 826916,
        'videos': {
          'medium': {'url': 'https://cdn.pixabay.com/video/medium.mp4'},
        },
      };

      final model = PixabayVideoModel.tryFromJson(json);

      expect(model, isNotNull);
      expect(model!.id, 228847);
      expect(model.name, 'waterfall, mountain stream, flow');
      expect(model.videoUrl, 'https://cdn.pixabay.com/video/medium.mp4');
      expect(model.likes, 5567);
      expect(model.views, 826916);
    });

    test('devuelve null cuando falta el id', () {
      final json = {
        'name': 'sin id',
        'videos': {
          'medium': {'url': 'https://cdn.pixabay.com/x.mp4'},
        },
      };

      expect(PixabayVideoModel.tryFromJson(json), isNull);
    });

    test('devuelve null cuando nungunal calidad tiene una url usable', () {
      final json = {
        'id': 1,
        'name': 'sin video',
        'videos': {
          'large': {'url': '', 'width': 0, 'height': 0},
          'medium': {'url': ''},
        },
      };

      expect(PixabayVideoModel.tryFromJson(json), isNull);
    });

    test('reproduce el caso real del video id 2266: "large" corrupto, "dedium" si sirve', () {
      // Este es el registro exacto que encontramos al probar en Bruno
      // en el Módulo 2 — su "large" apunta por error a un archivo
      // "_medium.mp4" con dimensiones en 0.
      final json = {
        'id': 2266,
        'name': 'mountains, clouds, fog',
        'likes': 1509,
        'views': 342590,
        'videos': {
          'large': {
            'url': 'https://cdn.pixabay.com/.../2266-157183287_medium.mp4',
            'width': 0,
            'height': 0,
            'size': 0,
          },
          'medium': {
            'url': 'https://cdn.pixabay.com/.../2266-157183287_medium.mp4',
            'width': 1280,
            'height': 720,
          },
        },
      };

      final model = PixabayVideoModel.tryFromJson(json);

      expect(model, isNotNull);
      expect(model!.videoUrl, contains('_medium.mp4'));
    });

    test('usa "small" cuando "medium" viene con url vacía', () {
      final json = {
        'id': 5,
        'name': 'fallback a small',
        'videos': {
          'medium': {'url': ''},
          'small': {'url': 'https://cdn.pixabay.com/small.mp4'},
        },
      };

      final model = PixabayVideoModel.tryFromJson(json);

      expect(model!.videoUrl, 'https://cdn.pixabay.com/small.mp4');
    });

    test('usa un nombre por defecto cuando "name" no viene', () {
      final json = {
        'id': 6,
        'videos': {
          'medium': {'url': 'https://cdn.pixabay.com/x.mp4'},
        },
      };

      final model = PixabayVideoModel.tryFromJson(json);

      expect(model!.name, 'Sin descripción');
    });

    test('acepta likes y views como double sin romperse', () {
      final json = {
        'id': 7,
        'name': 'numeros como double',
        'likes': 100.0,
        'views': 200.0,
        'videos': {
          'medium': {'url': 'https://cdn.pixabay.com/x.mp4'},
        },
      };

      final model = PixabayVideoModel.tryFromJson(json);

      expect(model!.likes, 100);
      expect(model.views, 200);
    });

    test('usa 0 como valor por defecto cuando likes y views no vienen', () {
      final json = {
        'id': 8,
        'name': 'sin likes ni views',
        'videos': {
          'medium': {'url': 'https://cdn.pixabay.com/x.mp4'},
        },
      };

      final model = PixabayVideoModel.tryFromJson(json);

      expect(model!.likes, 0);
      expect(model.views, 0);
    });
  });

  group('PixabayVideoModel.toVideoPostEntity', () {
    test('transforma el modelo en una entidad VideoPost equivalente', () {
      final model = PixabayVideoModel(
        id: 1,
        name: 'un video',
        videoUrl: 'https://cdn.pixabay.com/x.mp4',
        likes: 10,
        views: 20,
      );

      final entity = model.toVideoPostEntity();

      expect(entity.id, 1);
      expect(entity.caption, 'un video');
      expect(entity.videoUrl, 'https://cdn.pixabay.com/x.mp4');
      expect(entity.likes, 10);
      expect(entity.views, 20);
    });
  });
}

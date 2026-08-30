// test/presentation/widgets/shared/video_buttons_test.dart

import 'package:darttok/config/helpers/human_formats.dart';
import 'package:darttok/domain/entities/video_post.dart';
import 'package:darttok/presentation/widgets/shared/video_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final video = VideoPost(
    id: 1,
    caption: 'un video de prueba',
    videoUrl: 'https://cdn.pixabay.com/x.mp4',
    likes: 1005,
    views: 200,
  );

  Future<void> pumpVideoButtons(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: VideoButtons(video: video)),
      ),
    );
  }

  testWidgets('muestra el corazón vacío y el conteo inicial de likes', (
    tester,
  ) async {
    await pumpVideoButtons(tester);

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
    expect(
      find.text(HumanFormats.formatearNumeroLegible(video.likes.toDouble())),
      findsOneWidget,
    );
  });

  testWidgets('al tocar el corazón, se rellena y el contador sube en 1', (
    tester,
  ) async {
    await pumpVideoButtons(tester);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump(); // reconstruye el widget con el nuevo estado

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsNothing);
    expect(
      find.text(
        HumanFormats.formatearNumeroLegible((video.likes + 1).toDouble()),
      ),
      findsOneWidget,
    );
  });

  testWidgets('al tocarlo dos veces, vuelve al estado original', (
    tester,
  ) async {
    await pumpVideoButtons(tester);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(
      find.text(HumanFormats.formatearNumeroLegible(video.likes.toDouble())),
      findsOneWidget,
    );
  });
}

// main.dart

import 'package:darttok/config/theme/app_theme.dart';
import 'package:darttok/infrastructure/datasources/local_video_datasource_impl.dart';
import 'package:darttok/infrastructure/datasources/pixabay_datasource_impl.dart';
import 'package:darttok/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// TEMPORAL: esto se borra cuando conectemos todo con Provider en el Módulo 9.
Future<void> main() async {
  const apiKey = String.fromEnvironment('PIXABAY_API_KEY');

  final repositoty = VideoPostsRepositoryImpl(
    remoteDatasource: PixabayDatasourceImpl(dio: Dio(), apiKey: apiKey),
    localDatasource: LocalVideoDatasourceImpl(),
  );

  final videos = await repositoty.getPopularVideos();
  debugPrint(
    '✅ Repository entregó ${videos.length} videos. Primero: ${videos.first.caption}',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DartTok',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().theme(),
      // TEMPORAL: esta pantalla se reemplaza por ForYouScreen en el
      // Modulo 10. Solo existe para confirmar visualmente que el
      // ColorScheme.fromSeed de este modulo si se esta aplicando.
      home: const _ThemePreviewScreen(),
    );
  }
}

// Widget temporal, exclusivo de este modulo: se borra en el Modulo 10.
class _ThemePreviewScreen extends StatelessWidget {
  const _ThemePreviewScreen();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(height: 16),
            Text(
              'Tema aplicado',
              style: TextStyle(color: colorScheme.primary, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

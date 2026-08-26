import 'package:darttok/infrastructure/datasources/local_video_datasource_impl.dart';
import 'package:darttok/infrastructure/datasources/pixabay_datasource_impl.dart';
import 'package:darttok/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ... tus otros imports existentes

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('DartTok'))),
    );
  }
}

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

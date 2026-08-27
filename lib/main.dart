// main.dart

import 'package:darttok/config/theme/app_theme.dart';
import 'package:darttok/infrastructure/datasources/local_video_datasource_impl.dart';
import 'package:darttok/infrastructure/datasources/pixabay_datasource_impl.dart';
import 'package:darttok/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:darttok/presentation/providers/for_you_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const apiKey = String.fromEnvironment('PIXABAY_API_KEY');

    // El repository se arma una sola vez aqui, y se inyecta en el
    // provider. Si mañana cambiamos Pixabay por otra API, este en el
    // unico lugar del proyecto que se toca.
    final repository = VideoPostsRepositoryImpl(
      remoteDatasource: PixabayDatasourceImpl(dio: Dio(), apiKey: apiKey),
      localDatasource: LocalVideoDatasourceImpl(),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ForYouProvider(repository: repository)..loadNextPage(),
        ),
      ],
      child: MaterialApp(
        title: 'DartTok',
        debugShowCheckedModeBanner: false,
        theme: AppTheme().theme(),
        //TEMPORAL: se reemplaza por ForYouScreen en el Modulo 10.
        home: const _ProviderPreviewScreen(),
      ),
    );
  }
}

// Widget temporal, exclusivo de este modulo: se borra en el Modulo 10.
class _ProviderPreviewScreen extends StatelessWidget {
  const _ProviderPreviewScreen();

  @override
  Widget build(BuildContext context) {
    // LLAMANDO AL PROVIDER
    final forYouProvider = context.watch<ForYouProvider>();

    if (forYouProvider.initialLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (forYouProvider.hasError) {
      return const Scaffold(
        body: Center(child: Text('Ocurrio un error al cargar los videos')),
      );
    }
    return Scaffold(
      body: ListView.builder(
        itemCount: forYouProvider.videos.length,
        itemBuilder: (context, index) {
          final video = forYouProvider.videos[index];
          return ListTile(
            title: Text(video.caption),
            subtitle: Text('❤️ ${video.likes}  👁️ ${video.views}'),
          );
        },
      ),
    );
  }
}

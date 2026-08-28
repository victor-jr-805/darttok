// main.dart

import 'package:darttok/config/theme/app_theme.dart';
import 'package:darttok/infrastructure/datasources/local_video_datasource_impl.dart';
import 'package:darttok/infrastructure/datasources/pixabay_datasource_impl.dart';
import 'package:darttok/infrastructure/repositories/video_posts_repository_impl.dart';
import 'package:darttok/presentation/providers/for_you_provider.dart';
import 'package:darttok/presentation/screens/for_you/for_you_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:provider/provider.dart';

void main() {
  // Registra la implementación de fvp SOLO para Linux y Windows.
  // Android, iOS y Web siguen usando las implementaciones oficiales de
  // video_player sin ningún cambio — fvp filtra internamente en qué
  // plataforma actuar, así que es seguro llamarlo siempre.
  fvp.registerWith(
    options: {
      'platforms': ['windows', 'linux'],
    },
  );
  runApp(const MyApp());
}

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
        home: const ForYouScreen(),
      ),
    );
  }
}

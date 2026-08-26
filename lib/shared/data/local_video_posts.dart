// shared/data/local_video_posts.dart

import 'package:darttok/domain/entities/video_post.dart';

// Datos fijos para pruebas y como respaldo sin conexion.
// Usamos URLs de Pixabay directas (verificado en Bruno)
// en vez de assets empacados en la app, para no aumentar el peso del build,
// sobre todo en Web.
final List<VideoPost> localVideoPosts = [
  VideoPost(
    id: 1,
    caption: 'moraine lake, banff national park, canada nature',
    videoUrl: 'https://cdn.pixabay.com/video/2025/07/22/292827_medium.mp4',
    likes: 1005,
    views: 100040,
  ),
  VideoPost(
    id: 2,
    caption: 'clouds, storm, beautiful wallpaper',
    videoUrl: 'https://cdn.pixabay.com/video/2025/05/13/278750_medium.mp4',
    likes: 1035,
    views: 122942,
  ),
];

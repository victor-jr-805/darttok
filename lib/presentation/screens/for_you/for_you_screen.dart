// presentation/screens/for_you/for_you_screen.dart

import 'package:darttok/presentation/providers/for_you_provider.dart';
import 'package:darttok/presentation/widgets/shared/video_scrollable_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForYouScreen extends StatelessWidget {
  const ForYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // LLAMANDO AL PROVIDER
    final forYouProvider = context.watch<ForYouProvider>();

    return Scaffold(body: _buildBody(forYouProvider));
  }

  // Decide que mostrar segun el estado actual del provider
  Widget _buildBody(ForYouProvider provider) {
    if (provider.initialLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (provider.hasError) {
      return _ErrorView(onRetry: provider.loadNextPage);
    }

    if (provider.videos.isEmpty) {
      return const _EmptyView();
    }

    // TEMPORAL: se reemplaza por VideoScrollableView en el modulo 11.
    return VideoScrollableView(
      videos: provider.videos,
      onNearEnd: provider.loadNextPage,
    );
  }
}

// Estado de error con boton para reintentar la carga.
class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 48),
          const SizedBox(height: 12),
          const Text('No se pudieron cargar los videos'),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}

// Estado sin resultados (por ejemplo, si Pixabay y el respaldo local
// concideran en devolver una lista vacia).
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No hay videos disponibles por ahora'));
  }
}

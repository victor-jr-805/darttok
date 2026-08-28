// presentation/widgets/shared/video_buttons.dart
import 'package:darttok/config/helpers/human_formats.dart';
import 'package:darttok/config/theme/app_colors.dart';
import 'package:darttok/domain/entities/video_post.dart';
import 'package:flutter/material.dart';

class VideoButtons extends StatefulWidget {
  final VideoPost video;

  const VideoButtons({super.key, required this.video});

  @override
  State<VideoButtons> createState() => _VideoButtonsState();
}

class _VideoButtonsState extends State<VideoButtons> {
  // Estado local, exclusivo de este widget: no vive en el Provider
  // porque a ninguna otra pantalla le importa si este video en
  // particular tiene o no like.
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _likeCount = widget.video.likes;
  }

  void _toggleLike() {
    // Actualizacion optimista: cambiamos el numero de inmediato, sin
    // esperar ninguna respuesta de red (porque no hay ningun backend
    // real detras de este boton).
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CustomIconButton(
          value: _likeCount,
          iconData: _isLiked ? Icons.favorite : Icons.favorite_border,
          iconColor: _isLiked ? AppColors.like : AppColors.videoIcon,
          isActive: _isLiked,
          onTap: _toggleLike,
        ),
        const SizedBox(height: 20),
        _CustomIconButton(
          value: widget.video.views,
          iconData: Icons.remove_red_eye_outlined,
          // Las vistas no son interactivas: el "onTap" no hace nada,
          // solo mantenemos el mismo widget para que ambos iconos se
          // vean visualmente consistentes.
          onTap: () {},
        ),
      ],
    );
  }
}

// Widget privado reutilizable entre el boton de like y el contador de
// vistas, para no duplicar la estructura Colum + IconButton + Text.
class _CustomIconButton extends StatelessWidget {
  final int value;
  final IconData iconData;
  final Color? iconColor;
  final bool isActive;
  final VoidCallback onTap;

  const _CustomIconButton({
    required this.value,
    required this.iconData,
    required this.onTap,
    this.iconColor,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: AnimatedScale(
            scale: isActive ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: Icon(
              iconData,
              color: iconColor ?? AppColors.videoIcon,
              size: 36,
            ),
          ),
        ),
        Text(
          HumanFormats.formatearNumeroLegible(value.toDouble()),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

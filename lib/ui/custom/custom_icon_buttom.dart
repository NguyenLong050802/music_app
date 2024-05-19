import 'package:flutter/material.dart';

class MediaIconButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;
  final void Function()? onPressed;
  const MediaIconButton(
      {super.key,
      required this.icon,
      this.color,
      this.size,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: color ?? Theme.of(context).colorScheme.primary,
      iconSize: size,
      onPressed: onPressed,
    );
  }
}

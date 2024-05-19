import 'package:flutter/material.dart';

class MediaIconButton extends StatefulWidget {
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
  State<MediaIconButton> createState() => _MediaIconButtonState();
}

class _MediaIconButtonState extends State<MediaIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(widget.icon),
      color: widget.color ?? Theme.of(context).colorScheme.primary,
      iconSize: widget.size,
      onPressed: widget.onPressed,
    );
  }
}

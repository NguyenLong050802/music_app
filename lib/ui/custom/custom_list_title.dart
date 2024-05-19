import 'package:flutter/material.dart';

class MyListTitle extends StatelessWidget {
  final String title;
  final String? subTitle;
  final void Function()? onTap;
  final Widget? leading;
  final Widget? trailing;
  const MyListTitle({
    super.key,
    required this.title,
    this.subTitle,
    this.trailing,
    this.leading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 8, top: 5),
      title: Text(title),
      subtitle: subTitle != null ? Text(subTitle!) : null,
      onTap: onTap,
      trailing: trailing,
      leading: leading,
    );
  }
}

class Leading extends StatelessWidget {
  final String image;
  const Leading({super.key,required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/itunes.jfif',
          image: image,
          height: 48,
          width: 48,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/itunes.jfif',
              height: 48,
              width: 48,
            );
          },
        ));
  }
}

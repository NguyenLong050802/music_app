import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorMsg;
  final String? Function(String?)? onChanged;
  final bool? readOnly;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText,
    required this.labelText,
    this.keyboardType,
    this.suffixIcon,
    this.onTap,
    this.prefixIcon,
    this.validator,
    this.focusNode,
    this.errorMsg,
    this.onChanged,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFFedf0f8)),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        focusNode: focusNode,
        onTap: onTap,
        onChanged: onChanged,
        readOnly: readOnly ?? false,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onError,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          label: Text(labelText),
          labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.onError, fontSize: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFFedf0f8)),
          ),
          fillColor: const Color(0xFFedf0f8),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onError, fontSize: 20),
          errorText: errorMsg,
        ),
      ),
    );
  }
}

class MyTextButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const MyTextButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          maximumSize: const WidgetStatePropertyAll(Size(200, 50)),
          backgroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        ),
        child: Center(
          child: Text(title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 22,
              )),
        ));
  }
}

Widget avatar(String image, double height, double width) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/itunes.jfif',
        image: image,
        height: height,
        width: width,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/itunes.jfif',
            height: height,
            width: width,
          );
        },
      ));
}

void showMessage(String content, BuildContext context) {
  var snackBar = SnackBar(
    content: Text(
      content,
      style:
          TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.surface),
    ),
    backgroundColor: Theme.of(context).colorScheme.secondary,
    duration: const Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

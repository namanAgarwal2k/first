import 'package:flutter/material.dart';

class IconButton extends StatelessWidget {
  const IconButton({Key? key,
    required this.onPressed,
    required this.iconData,
    required this.text})
      : super(key: key);
  final VoidCallback? onPressed;
  final IconData? iconData;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed:
        onPressed,
        icon: Icon(iconData),
        label: Text(text!),
      ),
    );
  }
}

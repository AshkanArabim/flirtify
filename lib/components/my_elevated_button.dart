import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  String text;
  VoidCallback? onPressed;

  MyElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

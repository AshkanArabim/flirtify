import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String hint;
  TextEditingController? controller;
  bool obscureText;

  MyTextField({
    super.key,
    this.hint = "",
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(),
      ),
      controller: controller,
    );
  }
}

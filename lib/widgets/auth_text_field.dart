import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final Function(String)? onSubmit;
  final String? Function(String?)? validator;

  const AuthTextField({
    this.label,
    this.controller,
    this.onSubmit,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText:
          label == "Password" || label == "Confirm Password" ? true : false,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onFieldSubmitted: (value) {
        if (onSubmit != null) onSubmit!(value);
      },
      validator: validator,
    );
  }
}

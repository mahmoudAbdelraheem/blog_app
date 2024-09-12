import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController myController;
  const AuthField({
    super.key,
    required this.hint,
    required this.myController,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: myController,
          decoration: InputDecoration(
            hintText: hint,
          ),
          obscureText: isPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$hint cannot be empty';
            }
            return null;
          }),
    );
  }
}

import 'package:flutter/material.dart';
import '../consts/sizes.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;

  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.borderRadiusSmall),
          ),
        ),
        contentPadding: const EdgeInsets.all(AppSizes.paddingButtonContent),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.all(AppSizes.paddingButtonContent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}

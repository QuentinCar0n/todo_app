/*
 * 📱 Todo List App - Signup Page
 * 
 * Architecture:
 *  +------------------+
 *  |    SignUpPage    |
 *  |   (StatefulW)    |
 *  +--------+--------+
 *           |
 *  +--------v--------+
 *  |  Validation &   |
 *  |  Form Handling  |
 *  +--------+--------+
 *           |
 *  +--------v--------+
 *  |   Supabase      |
 *  |     Auth        |
 *  +----------------+
 */

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/form.dart';
import '../consts/sizes.dart';
import '../widgets/images.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  // 📧 Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  // 🔐 Password validation
  bool _isValidPassword(String password) {
    // Min length: 6, 1 special char, 1 number, 1 uppercase
    final hasMinLength = password.length >= 6;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return hasMinLength && hasUppercase && hasDigits && hasSpecialCharacters;
  }

  // 🔍 Validate input fields
  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = '❌ Email is required';
      } else if (!_isValidEmail(value)) {
        _emailError = '❌ Please enter a valid email';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = '❌ Password is required';
      } else if (!_isValidPassword(value)) {
        _passwordError = '''❌ Password must have:
• At least 6 characters
• At least 1 uppercase letter
• At least 1 number
• At least 1 special character''';
      } else {
        _passwordError = null;
      }
    });
  }

  Future<void> _signUp() async {
    // 🔍 Validate both fields before submission
    _validateEmail(_emailController.text);
    _validatePassword(_passwordController.text);

    if (_emailError == null && _passwordError == null) {
      try {
        await Supabase.instance.client.auth.signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } on AuthException catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${error.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingAroundForm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppSizes.paddingBetweenFormFields * 2),
            AppImages.logo(),
            const SizedBox(height: AppSizes.paddingBetweenFormFields * 2),
            AuthTextField(
              label: '📧 Email',
              controller: _emailController,
              onChanged: _validateEmail,
              errorText: _emailError,
            ),
            const SizedBox(height: AppSizes.paddingBetweenFormFields),
            AuthTextField(
              label: '🔐 Password',
              controller: _passwordController,
              obscureText: true,
              onChanged: _validatePassword,
              errorText: _passwordError,
            ),
            const SizedBox(height: AppSizes.paddingBetweenFormFields * 1.5),
            AuthButton(
              text: '✨ Create Account',
              onPressed: _signUp,
            ),
            const SizedBox(height: AppSizes.paddingBetweenFormFields),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Already have an account? Log in 🔑'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

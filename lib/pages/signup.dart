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

  Future<void> _signUp() async {
    try {
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/home');
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingAroundForm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImages.logo(),
            const SizedBox(height: AppSizes.paddingBetweenFormFields * 2),
            AuthTextField(
              label: 'Email',
              controller: _emailController,
            ),
            const SizedBox(height: AppSizes.paddingBetweenFormFields),
            AuthTextField(
              label: 'Password',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: AppSizes.paddingBetweenFormFields * 1.5),
            AuthButton(
              text: 'Create Account',
              onPressed: _signUp,
            ),
            const SizedBox(height: AppSizes.paddingBetweenFormFields),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Already have an account? Log in'),
            ),
          ],
        ),
      ),
    );
  }
}

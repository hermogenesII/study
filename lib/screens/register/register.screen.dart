import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study/screens/homepage/homepage.screen.dart';
import 'package:study/services/auth_service.dart';
import 'package:study/utils/auth/auth_validator.dart';
import 'package:study/widgets/auth_text_field.dart';

class RegistrationPageScreen extends StatefulWidget {
  const RegistrationPageScreen({super.key});
  static const routeName = '/register';
  @override
  State<RegistrationPageScreen> createState() => _RegistrationPageScreenState();
}

class _RegistrationPageScreenState extends State<RegistrationPageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (mounted) {
          context.replace(HomePageScreen.routeName);
        }
      } catch (e) {
        _showError(e.toString());
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///For Email
              AuthTextField(
                label: "Email",
                controller: _emailController,
                onSubmit: (value) => _signUp(),
                validator: AuthValidator.validateEmail,
              ),
              const SizedBox(height: 16),

              //For Password
              AuthTextField(
                label: "Password",
                controller: _passwordController,
                onSubmit: (value) => _signUp(),
                validator: AuthValidator.validatePassword,
              ),
              const SizedBox(height: 16),

              //For Confirm Password
              AuthTextField(
                label: "Confirm Password",
                onSubmit: (value) => _signUp(),
                validator:
                    (value) => AuthValidator.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => _signUp(),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:easy_design_system/easy_design_system.dart';
import 'package:study/screens/homepage/homepage.screen.dart';
import 'package:study/screens/register/register.screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study/services/auth_service.dart';
import 'package:study/utils/auth/auth_validator.dart';
import 'package:study/widgets/auth_text_field.dart';

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (mounted) {
          print("-----> User: ${_authService.getCurrentUserInfo()}");
          context.replace(HomePageScreen.routeName);
        }
      } catch (e) {
        _showError(e.toString());
      }
    }
  }

  // void _loginWithGoogle() async {
  //   try {
  //     await _authService.signInWithGoogle();
  //     await _rtdbService.saveUserInfoToRTDB(_authService.getCurrentUserInfo()!);
  //     if (mounted) context.replace(HomePageScreen.routeName);
  //   } catch (e) {
  //     _showError(e.toString());
  //   }
  // }

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
    return Theme(
      data: ComicTheme.of(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),

                ///For Email
                AuthTextField(
                  label: "Email",
                  controller: _emailController,
                  onSubmit: (value) => _login(),
                  validator: AuthValidator.validateEmail,
                ),
                const SizedBox(height: 16),

                //For Password
                AuthTextField(
                  label: "Password",
                  controller: _passwordController,
                  onSubmit: (value) => _login(),
                  validator: AuthValidator.validatePassword,
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () => _login(),
                  child: const Text('Login'),
                ),
                // ElevatedButton.icon(
                //   onPressed: () => _loginWithGoogle(),
                //   icon: const Icon(Icons.login),
                //   label: const Text('Sign in with Google'),
                // ),
                TextButton(
                  onPressed:
                      () => context.push(RegistrationPageScreen.routeName),
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

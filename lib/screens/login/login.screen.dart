import 'package:easy_design_system/easy_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study/screens/homepage/homepage.screen.dart';
import 'package:study/screens/register/register.screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study/services/auth_service.dart';
import 'package:study/services/rtdb_service.dart';

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _rtdbService = RTDBService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    print("clicked");
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        await _rtdbService.saveUserInfoToRTDB(
          _authService.getCurrentUserInfo()!,
        );

        await _authService.updateUserInfo(
          "user${_authService.getCurrentUserInfo()!.uid}",
          "",
        );
        print("Succesfully added to RTDB");
        context.replace(HomePageScreen.routeName);
      } catch (e) {
        _showError(e.toString());
      }
    }
  }

  void _loginWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      await _rtdbService.saveUserInfoToRTDB(_authService.getCurrentUserInfo()!);
      print("Successfully signed in with Google and added to RTDB");
      context.replace(HomePageScreen.routeName);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    print(msg);
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
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Email is required';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Password is required';
                    if (value.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _login(),
                  child: const Text('Login'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _loginWithGoogle(),
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                ),
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

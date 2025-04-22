import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study/screens/login/login.screen.dart';
import 'package:study/services/auth_service.dart';
import 'package:study/services/rtdb_service.dart';

class RegistrationPageScreen extends StatefulWidget {
  const RegistrationPageScreen({super.key});
  static const routeName = '/register';
  @override
  State<RegistrationPageScreen> createState() => _RegistrationPageScreenState();
}

class _RegistrationPageScreenState extends State<RegistrationPageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _rtdbService = RTDBService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp() async {
    print("Clicked");
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // await _rtdbService.saveUserInfoToRTDB(
        //   user: _emailController.text.trim(),
        // );
        context.replace(LoginPageScreen.routeName);
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
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    print('Email is required');
                    return 'Email is required';
                  }
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
                  if (value == null || value.trim().isEmpty) {
                    print("Password is required");
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be atleast 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Confirm Password is required';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
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

// class RegistrationPageScreen extends StatefulWidget {
//   static const routeName = '/register';
//   const RegistrationPageScreen({super.key});

//   @override
//   State<RegistrationPageScreen> createState() => RegistrationPageScreenState();
// }

// class RegistrationPageScreenState extends State<RegistrationPageScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _authService = AuthService();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   void _signUp() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await _authService.signUp(
//           _emailController.text.trim(),
//           _passwordController.text.trim(),
//         );
//         Navigator.pop(context);
//       } catch (e) {
//         _showError(e.toString());
//       }
//     }
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty)
//                     return 'Email is required';
//                   if (!value.contains('@')) return 'Enter a valid email';
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty)
//                     return 'Password is required';
//                   if (value.length < 6)
//                     return 'Password must be at least 6 characters';
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(onPressed: _signUp, child: const Text('Sign Up')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

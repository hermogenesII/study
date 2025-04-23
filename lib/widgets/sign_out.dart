import 'package:flutter/material.dart';
import 'package:study/services/auth_service.dart';
import 'package:easy_locale/easy_locale.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().signOut();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text('Logout'.t),
    );
  }
}

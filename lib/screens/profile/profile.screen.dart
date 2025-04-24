import 'package:flutter/material.dart';
import 'package:study/widgets/change_language.dart';
import 'package:study/widgets/profile_info.dart';
import 'package:study/widgets/sign_out.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [ChangeLanguage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(21.0),
        child: Column(
          children: [
            ProfileInfo(),
            const SizedBox(height: 20),
            SignOutButton(),
          ],
        ),
      ),
    );
  }
}

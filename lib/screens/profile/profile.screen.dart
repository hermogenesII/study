import 'package:flutter/material.dart';
import 'package:study/services/rtdb_service.dart';
import 'package:study/widgets/profile_avatart.dart';
import 'package:study/widgets/sign_out.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RTDBService _rtdbService = RTDBService();
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    final userInfo = await _rtdbService.getUserInformation();
    if (mounted) {
      setState(() {
        _userInfo = userInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _userInfo == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileAvatart(),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        _userInfo!['displayName'] ?? 'UserName',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        _userInfo!['email'] ?? 'Email not available',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'About Me',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bahay Kubo, Kahit Maliit na gagamba umakyat sa sanga',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    SignOutButton(),
                  ],
                ),
      ),
    );
  }
}

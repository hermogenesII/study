import 'package:flutter/material.dart';

class ProfileAvatart extends StatelessWidget {
  const ProfileAvatart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('images/profile1.jpeg'),
        ),
        onTap: () => print('Profile Avatar Tapped'),
      ),
    );
  }
}

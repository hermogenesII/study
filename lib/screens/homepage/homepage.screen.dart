import 'package:easy_design_system/easy_design_system.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study/screens/chat/chat_list.screen.dart';
import 'package:study/screens/profile/profile.screen.dart';
import 'package:study/services/auth_service.dart';

class HomePageScreen extends StatefulWidget {
  static const routeName = '/';
  const HomePageScreen({super.key, required this.title});
  final String title;

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    lo.set(key: 'Logout', locale: 'en', value: 'Logout');
    lo.set(key: 'Logout', locale: 'ko', value: '로그아웃');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ComicTheme.of(context),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title.t)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("User: ${_authService.getCurrentUserInfo()?.email}"),
              ElevatedButton(
                onPressed: () => context.push(ProfileScreen.routeName),
                child: Text('Profile'),
              ),
              ElevatedButton(
                onPressed: () => context.push(ChatListScreen.routeName),
                child: Text('Chat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

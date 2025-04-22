import 'package:easy_design_system/easy_design_system.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study/screens/chat/chat_list.screen.dart';
import 'package:study/screens/login/login.screen.dart';
import 'package:study/services/auth_service.dart';

class HomePageScreen extends StatefulWidget {
  static const routeName = '/';
  const HomePageScreen({super.key, required this.title});
  final String title;

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // String? locale = 'ko';

  final _authService = AuthService();

  // @override
  // void initState() {
  //   super.initState();
  //   lo.set(key: 'go to other page', locale: 'en', value: 'Go to Next page');
  //   lo.set(key: 'go to other page', locale: 'ko', value: '다음 페이지로 이동');
  // }

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
              Text("home".t),
              Text("User: ${_authService.getCurrentUserInfo()?.email}"),
              Text("User: ${_authService.getCurrentUserInfo()?.displayName}"),
              _authService.isLoggedIn() == true
                  ? ElevatedButton(
                    onPressed: () async => await _authService.signOut(),
                    child: Text('Sign Out'),
                  )
                  : ElevatedButton(
                    onPressed: () => context.push(LoginPageScreen.routeName),
                    child: Text('Login'),
                  ),
              ElevatedButton(
                onPressed: () => context.push(ChatListScreen.routeName),
                child: Text('Chat'.t),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

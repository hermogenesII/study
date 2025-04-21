import 'package:easy_locale/easy_locale.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study/screens/login/login.screen.dart';

class HomePageScreen extends StatefulWidget {
  static const routeName = '/';
  const HomePageScreen({super.key, required this.title});
  final String title;

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String? locale = 'ko';
  @override
  void initState() {
    super.initState();
    lo.set(key: 'go to other page', locale: 'en', value: 'Go to Next page');
    lo.set(key: 'go to other page', locale: 'ko', value: '다음 페이지로 이동');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title.t)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is Date Picker"),
            ElevatedButton(
              onPressed: () => context.push(LoginPageScreen.routeName),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_design_system/easy_design_system.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study/screens/chat/chat_list.screen.dart';
import 'package:study/screens/profile/profile.screen.dart';
import 'package:study/services/auth_service.dart';
import 'package:study/services/rtdb_service.dart';
import 'package:study/widgets/change_language.dart';

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
    RTDBService().setupPresence();
    // lo.set(key: 'Logout', locale: 'en', value: 'Logout');
    // lo.set(key: 'Logout', locale: 'ko', value: '로그아웃');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ComicTheme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title.t),
          actions: [ChangeLanguage()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("User: ${_authService.getCurrentUserInfo()?.email}"),
              ElevatedButton(
                onPressed: () => context.push(ProfileScreen.routeName),
                child: Text('profile'.t),
              ),
              ElevatedButton(
                onPressed: () => context.push(ChatListScreen.routeName),
                child: Text('chat'.t),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.t),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'profile'.t,
            ),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat'.t),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                // Navigate to Home
                break;
              case 1:
                context.push(ProfileScreen.routeName);
                break;
              case 2:
                context.push(ChatListScreen.routeName);
                break;
            }
          },
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Sample Side Navigation',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('home'.t),
                onTap: () {
                  // Navigate to Home
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('profile'.t),
                onTap: () {
                  context.push(ProfileScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('chat'.t),
                onTap: () {
                  context.push(ChatListScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

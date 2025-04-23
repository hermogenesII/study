import 'package:easy_design_system/easy_design_system.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study/screens/chat/chat_list.screen.dart';
import 'package:study/screens/profile/profile.screen.dart';
import 'package:study/services/auth_service.dart';
import 'package:study/utils/locale_setup.dart' as custom_locale;

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
        appBar: AppBar(
          title: Text(widget.title.t),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'en') {
                  custom_locale.LocaleService.instance.setLocale('en');
                } else if (value == 'ko') {
                  custom_locale.LocaleService.instance.setLocale('ko');
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(value: 'en', child: Text('English')),
                    PopupMenuItem(value: 'ko', child: Text('Korean')),
                  ],
              icon: Icon(Icons.language),
            ),
          ],
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home'.t, // Localized label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'profile'.t, // Localized label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'chat'.t, // Localized label
            ),
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
                  'Navigation Menu',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('home'.t), // Localized text
                onTap: () {
                  // Navigate to Home
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('profile'.t), // Localized text
                onTap: () {
                  context.push(ProfileScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('chat'.t), // Localized text
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

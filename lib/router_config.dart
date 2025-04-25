import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study/screens/chat/chat.screen.dart';
import 'package:study/screens/chat/chat_group.screen.dart';
import 'package:study/screens/chat/chat_list.screen.dart';
import 'package:study/screens/homepage/homepage.screen.dart';
import 'package:study/screens/login/login.screen.dart';
import 'package:study/screens/profile/profile.screen.dart';
import 'package:study/screens/register/register.screen.dart';
import 'auth_notifier.dart';

final authNotifier = AuthNotifier();

final routerConfig = GoRouter(
  initialLocation: HomePageScreen.routeName,
  refreshListenable: authNotifier,

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;
    final path = state.fullPath;

    final isOnLogin = path == LoginPageScreen.routeName;
    final isOnRegister = path == RegistrationPageScreen.routeName;

    if (!isLoggedIn && !(isOnLogin || isOnRegister)) {
      return LoginPageScreen.routeName;
    }

    if (isLoggedIn && (isOnLogin || isOnRegister)) {
      return HomePageScreen.routeName;
    }

    return null;
  },

  routes: [
    GoRoute(
      path: HomePageScreen.routeName,
      builder: (context, state) => const HomePageScreen(title: 'home'),
    ),
    GoRoute(
      path: LoginPageScreen.routeName,
      builder: (context, state) => const LoginPageScreen(),
    ),
    GoRoute(
      path: RegistrationPageScreen.routeName,
      builder: (context, state) => const RegistrationPageScreen(),
    ),
    GoRoute(
      path: ChatPageScreen.routeName,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ChatPageScreen(
          chatRoomId: data['roomID'],
          userName: data['userName'],
        );
      },
    ),
    GoRoute(
      path: ChatListScreen.routeName,
      builder: (context, state) => const ChatListScreen(),
    ),
    GoRoute(
      path: ProfileScreen.routeName,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: ChatGroupScreen.routeName,
      builder: (context, state) => const ChatGroupScreen(),
    ),
  ],
);

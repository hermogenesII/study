import 'package:flutter/material.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:go_router/go_router.dart';
import 'package:study/screens/chat/chat.screen.dart';
import 'package:study/screens/chat/chat_group.screen.dart';
import 'package:study/services/rtdb_service.dart';

class ChatListScreen extends StatefulWidget {
  static const routeName = '/chatlist';
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  final _rtdbService = RTDBService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatlists"),
        actions: [
          IconButton(
            onPressed: () => context.push(ChatGroupScreen.routeName),
            icon: Icon(Icons.group),
          ),
        ],
      ),
      body: FirebaseDatabaseListView(
        query: _rtdbService.database.ref().child('users'),
        itemBuilder: (context, snapshot) {
          final user = snapshot.value as Map<dynamic, dynamic>? ?? {};
          return Row(
            children: [
              Icon(
                Icons.circle,
                color:
                    user['status']['state'] == 'online'
                        ? Colors.green
                        : Colors.grey,
              ),
              Expanded(
                child: ListTile(
                  title: Text(user['displayName'] ?? 'Unknown'),
                  subtitle: Text(user['email'] ?? 'No email'),
                  onTap: () {
                    context.push(
                      ChatPageScreen.routeName,
                      extra: {
                        "roomID": user['uid'],
                        "userName": user['displayName'],
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [BottomNavigationBarItem(icon: Icon(Icons.chat_sharp))],
      // ),
    );
  }
}

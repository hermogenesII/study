import 'package:easy_design_system/easy_design_system.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart'; // Import firebase_ui_database
import 'package:firebase_database/firebase_database.dart';
// import 'package:study/services/auth_service.dart';

class ChatListScreen extends StatefulWidget {
  static const routeName = '/chatlist';
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  // final AuthService _authService = AuthService();
  // String? _currentUserDisplayName;

  @override
  void initState() {
    super.initState();
    // _fetchCurrentUserDisplayName();
  }

  // Future<void> _fetchCurrentUserDisplayName() async {
  //   final user = _authService.getCurrentUserInfo();
  //   setState(() {
  //     _currentUserDisplayName = user?.displayName ?? 'Guest';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ComicTheme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chatlists"),
          // actions: [
          //   if (_currentUserDisplayName != null)
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Center(
          //         child: Text(
          //           'Hi, $_currentUserDisplayName',
          //           style: TextStyle(fontSize: 16),
          //         ),
          //       ),
          //     ),
          // ],
        ),
        body: FirebaseDatabaseListView(
          query: _database.child('users'), // Adjust the query path as needed
          itemBuilder: (context, snapshot) {
            final user = snapshot.value as Map<dynamic, dynamic>? ?? {};
            return ListTile(
              title: Text(user['displayName'] ?? 'Unknown'),
              subtitle: Text(user['email'] ?? 'No email'),
              onTap: () {
                // Handle user selection
              },
            );
          },
        ),
      ),
    );
  }
}

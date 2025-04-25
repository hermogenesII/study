import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';
import 'package:study/services/rtdb_service.dart';

class ChatGroupScreen extends StatefulWidget {
  const ChatGroupScreen({super.key});
  static const routeName = '/createGroup';

  @override
  State<ChatGroupScreen> createState() => _ChatGroupScreenState();
}

class _ChatGroupScreenState extends State<ChatGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  List<String> selectedUsers = [];

  handleCreateGroup() {
    final groupName = groupNameController.text.trim();
    if (groupName.isNotEmpty) {
      RTDBService().createGroup(groupName, selectedUsers);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Group "$groupName" created!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a group name.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),

            Column(
              children:
                  selectedUsers
                          .map(
                            (item) => ListTile(
                              title: Text(item),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () {
                                  selectedUsers.remove(item);
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                          .toList()
                      as List<Widget>,
            ),
            ElevatedButton(
              onPressed: handleCreateGroup,
              child: Text('Create Group'),
            ),
            Divider(color: Colors.grey, thickness: 1),
            SizedBox(height: 20),
            Text("Users"),
            Expanded(
              child: FirebaseDatabaseListView(
                query: RTDBService().database.ref().child('users'),
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
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          selectedUsers.add(
                            user['fullName'] ?? user['displayName'],
                          );
                          print('selectedUsers-------> $selectedUsers');
                          setState(() {});
                        },
                        icon: Icon(Icons.add_circle),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

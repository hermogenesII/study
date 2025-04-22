import 'package:easy_design_system/easy_design_system.dart';
import 'package:flutter/material.dart';

class ChatPageScreen extends StatefulWidget {
  static const routeName = '/chat';
  const ChatPageScreen({super.key});

  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ComicTheme.of(context),
      child: Scaffold(
        appBar: AppBar(title: Text("Chats")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(child: Text("Hi")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // TextField(
                  //   decoration: const InputDecoration(
                  //     labelText: 'Type a message,',

                  //   ),
                  // ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.send)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

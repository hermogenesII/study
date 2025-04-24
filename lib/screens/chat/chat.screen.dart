import 'package:easy_design_system/easy_design_system.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';
import 'package:study/services/auth_service.dart';
import 'package:study/services/rtdb_service.dart';
import 'package:study/widgets/chat_text_field.dart';

class ChatPageScreen extends StatefulWidget {
  static const routeName = '/chat';
  final String chatRoomId;

  const ChatPageScreen({required this.chatRoomId, super.key});

  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  List status = [];
  AuthService authService = AuthService();
  RTDBService rtdbService = RTDBService();
  TextEditingController textController = TextEditingController();

  String get chatRoomId =>
      ([widget.chatRoomId, AuthService().getCurrentUserInfo()!.uid]
        ..sort()).join("--");

  Future<void> _sendMessage(String? value) async {
    String message = textController.text.trim();
    if (message.isEmpty) return;
    await rtdbService.sendMessage(message, chatRoomId);
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ComicTheme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            stream:
                rtdbService.database
                    .ref("users/${widget.chatRoomId}/status")
                    .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  (snapshot.data! as DatabaseEvent).snapshot.value != null) {
                final data =
                    (snapshot.data! as DatabaseEvent).snapshot.value as Map;
                final state = data["state"];
                final lastChanged = DateTime.fromMillisecondsSinceEpoch(
                  data["last_changed"],
                );

                return Column(
                  children: [
                    Text(widget.chatRoomId),
                    Text(
                      state == "online" ? "Online" : "Last seen: $lastChanged",
                    ),
                  ],
                );
              } else {
                return Text("Loading...");
              }
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: FirebaseDatabaseListView(
                reverse: true,
                reverseQuery: true,
                query: rtdbService.database.ref('chats/$chatRoomId'),
                itemBuilder: (_, snapshot) {
                  final data = snapshot.value as Map;
                  final isCurrentUser =
                      data['senderId'] == authService.getCurrentUserInfo()!.uid;
                  return Align(
                    alignment:
                        isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['message'], style: TextStyle(fontSize: 16)),
                          SizedBox(height: 5),
                          Text(
                            DateTime.fromMillisecondsSinceEpoch(
                              data['createdAt'],
                            ).toString(),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ChatTextField(
              textController: textController,
              onSendMessage: (value) => _sendMessage(value),
            ),
          ],
        ),
      ),
    );
  }
}

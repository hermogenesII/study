import 'package:easy_design_system/easy_design_system.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study/services/auth_service.dart';
import 'package:study/services/rtdb_service.dart';
import 'package:study/widgets/chat_text_field.dart';

class ChatPageScreen extends StatefulWidget {
  static const routeName = '/chat';
  final String chatRoomId;
  final String? userName;

  const ChatPageScreen({required this.chatRoomId, this.userName, super.key});

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
    String? imageUrl =
        "https://firebasestorage.googleapis.com/v0/b/withcenter-test-4.appspot.com/o/posts%2F1742810074288.jpg?alt=media&token=a7766d9f-39da-4e5a-9d3a-a65e629f7015";
    String message = textController.text.trim();
    if (message.isEmpty) return;
    await rtdbService.sendMessage(message, imageUrl, chatRoomId);
    textController.clear();
  }

  Future<String?> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   print("Image path: ${image.path}");
    // }
    // return null;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ComicTheme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            stream:
                rtdbService.database.ref("users/${widget.chatRoomId}").onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  (snapshot.data! as DatabaseEvent).snapshot.value != null) {
                final data =
                    (snapshot.data! as DatabaseEvent).snapshot.value as Map;
                final state = data["status"]["state"];
                final lastChanged = DateTime.fromMillisecondsSinceEpoch(
                  data["status"]["last_changed"],
                );

                return Column(
                  children: [
                    Text(data["displayName"]),
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
                          data["message"].runtimeType == String
                              ? Text(data['message'])
                              : (data["message"]["image"] != null
                                  ? Image.network(data['message']['image'])
                                  : Text("")),
                          // if (data['message']["image"] != null)
                          //   Image.network(data['message']['image']),
                          // if (data['message']["text"] != null)
                          //   Text(
                          //     data['message']["text"],
                          //     style: TextStyle(fontSize: 16),
                          //   ),
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
              pickImage: (_) => _pickImage(),
            ),
          ],
        ),
      ),
    );
  }
}

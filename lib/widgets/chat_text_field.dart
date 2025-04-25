import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  final TextEditingController? textController;
  final Function(String?)? pickImage;
  final Function(String?)? onSendMessage;

  const ChatTextField({
    this.textController,
    this.pickImage,
    this.onSendMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          IconButton(
            onPressed: () => pickImage!(null),
            icon: Icon(Icons.camera_alt),
            iconSize: 49,
          ),
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Type a message,'),
              onSubmitted: (value) {
                if (onSendMessage != null) onSendMessage!(value);
              },
            ),
          ),
          IconButton(
            onPressed: () => onSendMessage!(textController?.text),
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flirtify/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatelessWidget {
  DocumentReference chatRef;
  ChatPage({
    super.key,
    required this.chatRef,
  });

  @override
  Widget build(BuildContext context) {
    final messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat page!"),
      ), // TODO: show name of chat
      body: Column(
        children: [
          // chat area
          Expanded(
            child: Container(), // debug
            // child: StreamBuilder(
            //   stream: stream, // TODO: stream goes here
            //   builder: (context, snapshot) {
            //     // TODO:
            //   },
            // ),
          ),
          // fixed textbox on the bottom
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  hint: "Type a message...",
                  controller: messageController,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // TODO: send message
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

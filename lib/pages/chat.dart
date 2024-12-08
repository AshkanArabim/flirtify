import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flirtify/components/chat_avatar.dart';
import 'package:flirtify/components/chat_name.dart';
import 'package:flirtify/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatelessWidget {
  // receiving chatRef because subcollections can only be accessed from DocumentReferences
  DocumentReference chatRef;
  ChatPage({
    super.key,
    required this.chatRef,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: StreamBuilder(
          stream: chatRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('loading...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final chat = (snapshot.data as DocumentSnapshot).data()
                as Map<String, dynamic>;
            return Row(children: [
              ChatAvatar(chat: chat),
              SizedBox(width: 15),
              ChatName(chat: chat),
            ]);
          },
        ),
      ),
      body: Column(
        children: [
          messagesContainer(),
          newMessageBar(),
        ],
      ),
    );
  }

  Expanded messagesContainer() {
    return Expanded(
      child: StreamBuilder(
        stream: chatRef.collection('messages').snapshots(),
        builder: (context, snapshot) {
          return Container(); // TODO: actually render stuff...
        },
      ),
    );
  }

  Row newMessageBar() {
    final messageController = TextEditingController();
    return Row(
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
    );
  }
}

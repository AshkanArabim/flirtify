import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flirtify/components/chat_avatar.dart';
import 'package:flirtify/components/chat_name.dart';
import 'package:flirtify/components/my_text_field.dart';
import 'package:flirtify/utils/ref_utils.dart';
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
          messagesContainer(context),
          newMessageBar(),
        ],
      ),
    );
  }

  Expanded messagesContainer(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: chatRef.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            final messages = ((snapshot.data as QuerySnapshot).docs
                    as List<DocumentSnapshot>)
                .map((message) => (message.data() as Map<String, dynamic>))
                .toList();

            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messageBubble(context, messages[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget messageBubble(BuildContext context, Map<String, dynamic> message) {
    final messsageDateTime = (message['timestamp'] as Timestamp).toDate();
    final messageTimeString =
        "${messsageDateTime.hour}:${messsageDateTime.minute.toString().padLeft(2, '0')}";

    final currentUserRefFuture = getCurrentUserRef();

    return FutureBuilder(
      future: currentUserRefFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          return Row(
            // container holding the message bubble
            mainAxisAlignment: (snapshot.data as DocumentReference ==
                    message['sender'] as DocumentReference)
                ? (MainAxisAlignment.end)
                : (MainAxisAlignment.start),
            children: [
              Row(
                // colored message bubble
                children: [
                  Text(
                    message['body'],
                    softWrap: true,
                  ),
                  Text(
                    messageTimeString,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              )
            ],
          );
        }
      },
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

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
          final isCurrentUser = (snapshot.data as DocumentReference) ==
              message['sender'] as DocumentReference;
          return Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Theme.of(context).primaryColor : Theme.of(context).focusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['body'],
                      style: TextStyle(
                        color: isCurrentUser ? Colors.white : Colors.black,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(height: 5),
                    Text(
                      messageTimeString,
                      style: TextStyle(
                        fontSize: 10,
                        color: isCurrentUser ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
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

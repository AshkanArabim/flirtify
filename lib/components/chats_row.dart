import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flirtify/components/chat_avatar.dart';
import 'package:flirtify/pages/chat.dart';
import 'package:flirtify/utils/ref_utils.dart';
import 'package:flutter/material.dart';

class ChatsRow extends StatelessWidget {
  final DocumentReference<Map<String, dynamic>> chatRef;

  const ChatsRow({
    super.key,
    required this.chatRef,
  });

  @override
  Widget build(BuildContext context) {
    final lastMessageStream = chatRef
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: chatRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data!.exists) {
          final chat = snapshot.data!.data()!;
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(chatRef: chatRef),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Colors.black12),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChatAvatar(chat: chat),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              chatName(chat),
                              lastMessageTextAndTime(lastMessageStream)
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text("Chat not found");
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> lastMessageTextAndTime(
      Stream<QuerySnapshot<Map<String, dynamic>>> lastMessageStream) {
    return StreamBuilder(
      stream: lastMessageStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(""); // empty
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final timestamp = snapshot.data!.docs.first["timestamp"] as Timestamp;
          final dateTime = timestamp.toDate();
          final now = DateTime.now();
          String timeString;

          if (dateTime.year != now.year) {
            timeString = "${dateTime.year}/${dateTime.month}/${dateTime.day}";
          } else if (dateTime.month != now.month || dateTime.day != now.day) {
            timeString = "${dateTime.month}/${dateTime.day}";
          } else {
            timeString =
                "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
          }

          final lastMessageText = Text(
            snapshot.data!.docs.first["body"],
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          );

          return Row(
            children: [
              Expanded(child: lastMessageText),
              Text(timeString),
            ],
          );
        } else {
          return const Text(""); // empty
        }
      },
    );
  }

  Widget chatName(Map<String, dynamic> chat) {
    Future<String> dmEmailFuture() async {
      final partnerRef = await getPartnerRef(chat);
      final partnerSnapshot = await partnerRef.get();
      return partnerSnapshot['email'];
    }

    if (chat['participants']!.length > 2) {
      return Text(chat['name'] ?? 'Untitled Group');
    } else {
      return FutureBuilder(
        future: dmEmailFuture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          } else if (snapshot.hasData) {
            return Text(snapshot.data!);
          } else {
            return const Text("Error loading email");
          }
        },
      );
    }
  }
}

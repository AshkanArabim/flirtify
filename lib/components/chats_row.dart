import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flirtify/pages/chat.dart';
import 'package:flutter/material.dart';

class ChatsRow extends StatelessWidget {
  QueryDocumentSnapshot<Map<String, dynamic>> chatSnapshot;

  ChatsRow({
    super.key,
    required this.chatSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    final chat = chatSnapshot.data();
    final lastMessageStream = chatSnapshot.reference
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(chatRef: chatSnapshot.reference),
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
                  chatAvatar(chat),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chat['name'] ?? 'Untitled Chat'),
                        StreamBuilder(
                          stream: lastMessageStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(""); // empty
                            } else if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              return Text(
                                snapshot.data!.docs.first["body"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              );
                            } else {
                              return const Text("No messages...");
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder(
                        stream: lastMessageStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(""); // empty
                          } else if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            final timestamp = snapshot
                                .data!.docs.first["timestamp"] as Timestamp;
                            final dateTime = timestamp.toDate();
                            final now = DateTime.now();
                            String timeString;

                            if (dateTime.year != now.year) {
                              timeString =
                                  "${dateTime.year}/${dateTime.month}/${dateTime.day}";
                            } else if (dateTime.month != now.month ||
                                dateTime.day != now.day) {
                              timeString = "${dateTime.month}/${dateTime.day}";
                            } else {
                              timeString =
                                  "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
                            }

                            return Text(timeString);
                          } else {
                            return const Text("");
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CircleAvatar chatAvatar(Map<String, dynamic> chat) {
    Widget avatarContent;
    if (chat['participants']!.length > 2) {
      avatarContent = Image.network(
        chat['grouppic'] ?? "",
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const CircularProgressIndicator();
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.group);
        },
      );
    } else {
      Future<String> dmProfileFuture() async {
        // get both participants of the chat
        final participants = (chat['participants'] as List<dynamic>).map(
          (p) => (p as DocumentReference),
        );

        // get the current user
        final currentUserSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .get();
        final DocumentReference currentUserRef =
            currentUserSnapshot.docs.first.reference;

        // exclude the current user from participants
        final partnerRef = participants
            .firstWhere((participant) => participant != currentUserRef);

        // return other participant's profile link
        final partnerSnapshot = await partnerRef.get();
        return partnerSnapshot['profilePicURL'];
      }

      avatarContent = FutureBuilder(
        future: dmProfileFuture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Icon(Icons.error);
          } else {
            return Image.network(
              fit: BoxFit.cover,
              width: 100,
              height: 100,
              snapshot.data ?? "",
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) => Icon(Icons.person),
            );
          }
        },
      );
    }
    return CircleAvatar(
      child: ClipOval(
        child: avatarContent,
      ),
    );
  }
}

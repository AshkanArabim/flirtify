import 'package:cloud_firestore/cloud_firestore.dart';
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
        print('clicked');
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
                  CircleAvatar(
                    child: Image.network(
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
                    ),
                  ),
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
}

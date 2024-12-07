import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  final Map<String, dynamic> chat;
  const ChatAvatar({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
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

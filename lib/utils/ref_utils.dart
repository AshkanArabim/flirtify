import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<DocumentReference> getPartnerRef(Map<String, dynamic> chat) async {
  // assuming the chat only has two participants
  if (chat['participants']!.length > 2) {
    throw Exception(
      "Expected chat with 2 participants, got chat with ${chat['participants']!.length} participants",
    );
  }

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
  return participants
      .firstWhere((participant) => participant != currentUserRef);
}

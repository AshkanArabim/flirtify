import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flirtify/providers/current_user_ref_provider.dart';
import 'package:flutter/material.dart';

DocumentReference getPartnerRef(
    Map<String, dynamic> chat, BuildContext context) {
  // assuming the chat only has two participants
  assert(
    chat['participants']!.length > 2,
    "Expected chat with 2 participants, got chat with ${chat['participants']!.length} participants",
  );

  // get both participants of the chat
  final participants = (chat['participants'] as List<dynamic>).map(
    (p) => (p as DocumentReference),
  );

  // get the current user
  final DocumentReference currentUserRef =
      CurrentUserRefProvider.of(context).currentUserRef;

  // exclude the current user from participants
  return participants
      .firstWhere((participant) => participant != currentUserRef);
}

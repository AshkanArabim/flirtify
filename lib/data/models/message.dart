import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flirtify/data/repositories/firestore_funcs.dart';

class Message {
  final String id;
  final DateTime timestamp;
  final DocumentReference sender;
  final String body;

  Message({
    required this.id,
    required int timestamp,
    required this.sender,
    required this.body,
  }) : timestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      timestamp: map['timestamp'],
      sender: map['sender'],
      body: map['body'],
    );
  }

  static Future<Message> fromRef(DocumentReference ref) async {
    return ref.get().then((doc) {
      if (doc.exists) {
        final map = doc.data() as Map<String, dynamic>;
        return Message.fromMap(map);
      } else {
        throw Exception('Message not found');
      }
    }).catchError((error) {
      throw Exception('Error getting message: $error');
    });
  }

  static fromId(String id) async {
    return fromRef(getMessageRefById(id));
  }
}

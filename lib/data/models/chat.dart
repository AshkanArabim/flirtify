import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flirtify/data/repositories/firestore_funcs.dart';

// TODO: remove this...
// class Chat {
//   final String id;
//   final List<String> participants; // ref
//   final List<String> messages; // ref

//   Chat._({
//     required this.id,
//     required this.participants,
//     required this.messages,
//   });

//   factory Chat.fromMap(Map<String, dynamic> json) {
//     return Chat._(
//       id: json['id'],
//       participants: List<String>.from(json['participants']),
//       messages: List<String>.from(json['messages']),
//     );
//   }

//   factory Chat.fromId(String id) {
//     // fetch chat data based on ID
//     getChatJsonById(id).then((json) {
//       // assign self values based on returned json values
//       return Chat.fromMap(json);
//     });
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'participants': participants,
//       'messages': messages,
//     };
//   }
// }

class Chat {
  final String id;
  final List<DocumentReference> participants;
  final List<DocumentReference> messages;

  Chat({
    required this.id,
    required this.participants,
    required this.messages,
  });

  // TODO: adjust these to get the id from the doc ref. currently relying on string ids
  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      participants: List<DocumentReference>.from(map['participants']),
      messages: List<DocumentReference>.from(map['messages']),
    );
  }

  static Future<Chat> fromRef(DocumentReference ref) async {
    return ref.get().then((doc) {
      if (doc.exists) {
        final map = doc.data() as Map<String, dynamic>;
        return Chat.fromMap(map);
      } else {
        throw Exception('Chat not found');
      }
    }).catchError((error) {
      throw Exception('Error getting chat: $error');
    });
  }

  static Future<Chat> fromId(String id) async {
    return fromRef(getChatRefById(id));
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'participants': participants,
  //     'messages': messages,
  //   };
  // }
}

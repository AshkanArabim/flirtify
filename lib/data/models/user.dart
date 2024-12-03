import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flirtify/data/repositories/firestore_funcs.dart';

class User {
  final String id;
  String username;
  String profilePicURL;
  String password;
  List<DocumentReference> chats;

  User({
    required this.id,
    required this.username,
    required this.profilePicURL,
    required this.password,
    this.chats = const [],
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      profilePicURL: json['profilePicURL'],
      password: json['password'],
    );
  }

  static Future<User> fromRef(DocumentReference ref) async {
    return ref.get().then((doc) {
      if (doc.exists) {
        final map = doc.data() as Map<String, dynamic>;
        return User.fromMap(map);
      } else {
        throw Exception('User not found');
      }
    }).catchError((error) {
      throw Exception('Error getting user: $error');
    });
  }

  static Future<User> fromId(String id) async {
    return fromRef(getUserRefById(id));
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'username': username,
  //     'profilePicURL': profilePicURL,
  //     'password': password,
  //   };
  // }
}

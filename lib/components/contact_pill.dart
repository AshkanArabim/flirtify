import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactPill extends StatelessWidget {
  final DocumentReference userRef;

  const ContactPill({
    super.key,
    required this.userRef,
  });

  @override
  Widget build(BuildContext context) {
    Future<String> getEmail() async {
      final userMap = (await userRef.get()).data() as Map<String, dynamic>;
      assert(userMap != null, "User with passed ref doesn't exist.");
      return userMap['email'];
    }

    return FutureBuilder(
      future: getEmail(),
      builder: (context, snapshot) {
        Widget emailText;

        if (snapshot.connectionState == ConnectionState.waiting) {
          emailText = CircularProgressIndicator();
        } else if (snapshot.hasError) {
          emailText = Text('Error: ${snapshot.error}');
        } else {
          emailText = Text(snapshot.data ?? 'No Email');
        }

        return IconTheme(
          data: IconThemeData(color: Colors.white),
          child: DefaultTextStyle(
            style: TextStyle(
              color: Colors.white,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  emailText,
                  Icon(Icons.close),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

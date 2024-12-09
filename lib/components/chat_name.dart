import 'package:flirtify/utils/ref_utils.dart';
import 'package:flutter/material.dart';

class ChatName extends StatelessWidget {
  final Map<String, dynamic> chat;

  const ChatName({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    Future<String> dmEmailFuture() async {
      final partnerRef = getPartnerRef(chat, context);
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

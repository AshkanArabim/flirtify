import 'package:flutter/material.dart';
import './ChatsRow.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clearchat'),
        backgroundColor: Colors.black12,
      ),
      body: ListView(
        children: [
          ChatsRow(),
          ChatsRow(),
          ChatsRow(),
        ],
      ),
    );
  }
}

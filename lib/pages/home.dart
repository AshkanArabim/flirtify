import 'package:flutter/material.dart';
import '../components/chats_row.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

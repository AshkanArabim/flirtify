import 'package:flutter/material.dart';
import '../components/chats_row.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void handleLogout() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            DrawerRow(
              icon: Icon(Icons.logout),
              label: "Log Out",
              func: handleLogout,
            )
          ],
        ),
      ),
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

  InkWell DrawerRow({
    required Icon icon,
    required GestureTapCallback func,
    required String label,
  }) {
    return InkWell(
      onTap: func,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

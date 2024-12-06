import 'package:cloud_firestore/cloud_firestore.dart';
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
    final firestore = FirebaseFirestore.instance;

    final chatsStream = firestore.collection('chats').snapshots();

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
        title: Text('Flirtify'),
        backgroundColor: Colors.black12,
      ),
      body: StreamBuilder(
        stream: chatsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final chat = snapshot.data!.docs[index];
                return ChatsRow(
                  chat: chat.data(),
                );
              },
              itemCount: snapshot.data!.docs.length,
            );
          } else {
            return Text("Snapshot has no data...");
          }
        },
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

import 'package:flirtify/components/contact_pill.dart';
import 'package:flirtify/components/my_text_field.dart';
import 'package:flirtify/providers/current_user_ref_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewChatPage extends StatelessWidget {
  const NewChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('New Chat'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: emailController,
                    hint: "Type email to add",
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO:
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  ContactPill(
                      userRef:
                          CurrentUserRefProvider.of(context).currentUserRef),
                  ContactPill(
                      userRef:
                          CurrentUserRefProvider.of(context).currentUserRef),
                  ContactPill(
                      userRef:
                          CurrentUserRefProvider.of(context).currentUserRef),
                  ContactPill(
                      userRef:
                          CurrentUserRefProvider.of(context).currentUserRef),
                ],
              ),
            ),
            MyTextField(
              hint: "Group picture URL",
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              hint: "Group name",
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: Text('Create'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

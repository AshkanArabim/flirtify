import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flirtify/components/contact_pill.dart';
import 'package:flirtify/components/my_text_field.dart';
import 'package:flirtify/providers/current_user_ref_provider.dart';
import 'package:flirtify/utils/ref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  List<DocumentReference> _participants = [];
  String _userAddingError = "";
  String _chatCreationError = "";
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    controller: _emailController,
                    hint: "Type email to add",
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final email = _emailController.text;

                    if (email.isEmpty) {
                      setState(() {
                        _userAddingError =
                            "Type an email before trying to add it!";
                      });
                      return;
                    }

                    DocumentReference? userRef = await getUserRefByEmail(email);
                    if (userRef == null) {
                      setState(() {
                        _userAddingError = "User not found!";
                      });
                      return;
                    }

                    setState(() {
                      _userAddingError = "";
                      _chatCreationError = "";
                      _emailController.text = "";
                      _participants.add(userRef);
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),

            // only render when there's something to show
            // padding while empty looks ugly
            (_participants.length > 0)
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: _participants
                          .map((userRef) => ContactPill(userRef: userRef))
                          .toList(),
                    ),
                  )
                : Container(),

            // show error if present
            _userAddingError.isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      _userAddingError,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  )
                : Container(),

            // only allow setting group pic and group name if at least 2 other
            // participants added to group. because otherwise it's just a DM.
            (_participants.length > 1)
                ? (Column(
                    children: [
                      SizedBox(height: 10),
                      MyTextField(
                        hint: "Group picture URL",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        hint: "Group name",
                      ),
                    ],
                  ))
                : Container(),
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

import 'dart:collection';

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
  final _participants = HashSet<DocumentReference>();
  var _userAddingError = "";
  var _chatCreationError = "";

  final _emailController = TextEditingController();
  final _groupPicUrlController = TextEditingController();
  final _groupNameController = TextEditingController();

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
                      children: _participants.map((userRef) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _participants.remove(userRef);
                            });
                          },
                          child: ContactPill(userRef: userRef),
                        );
                      }).toList(),
                    ),
                  )
                : Container(),

            // show error if present
            errorMessage(_userAddingError),

            // only allow setting group pic and group name if at least 2 other
            // participants added to group. because otherwise it's just a DM.
            (_participants.length > 1)
                ? (Column(
                    children: [
                      SizedBox(height: 10),
                      MyTextField(
                        hint: "Group picture URL",
                        controller: _groupPicUrlController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        hint: "Group name",
                        controller: _groupNameController,
                      ),
                    ],
                  ))
                : Container(),

            // render chat creation errors if needed
            errorMessage(_chatCreationError),

            // submit button
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: Text('Create'),
              onPressed: () async {
                // don't create if no other participants added
                if (_participants.isEmpty) {
                  setState(() {
                    _chatCreationError =
                        "You must add at least one participant to create a chat!";
                  });
                  return;
                }

                // create the chat
                final participantsList = _participants.toList();
                participantsList
                    .add(CurrentUserRefProvider.of(context).currentUserRef);
                var chatMap = Map<String, dynamic>();
                // var chatMap = {
                //   "participants": participantsList,
                // } as Map<String, dynamic>;
                if (_groupNameController.text.isNotEmpty) {
                  chatMap['name'] = _groupNameController.text;
                }

                chatMap['participants'] = participantsList;

                if (_groupPicUrlController.text.isNotEmpty) {
                  chatMap['grouppic'] = _groupPicUrlController.text;
                }

                await FirebaseFirestore.instance
                    .collection('chats')
                    .add(chatMap);

                // pop the new chat page
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget errorMessage(String message) {
    if (message.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    }
    return Container();
  }
}

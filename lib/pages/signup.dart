import 'package:flirtify/components/my_elevated_button.dart';
import 'package:flirtify/components/my_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // basic message
            Text("Create an account to start flirting!"),

            // fields
            SizedBox(
              height: 15,
            ),
            MyTextField(
              hint: "Email",
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              hint: "Password",
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              hint: "Repeat Password",
            ),

            // submit button
            SizedBox(
              height: 15,
            ),
            MyElevatedButton(
              text: "Sign Up",
              onPressed: () {},
            ),

            // link to signup page
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

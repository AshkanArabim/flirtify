import 'package:flirtify/components/my_elevated_button.dart';
import 'package:flirtify/components/my_text_field.dart';
import 'package:flirtify/pages/signup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
            Text("Welcome back! Sign in to continue flirting."),

            // fields
            SizedBox(
              height: 15,
            ),
            MyTextField(
              hint: "Username",
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              hint: "Password",
            ),

            // submit button
            SizedBox(
              height: 15,
            ),
            MyElevatedButton(
              text: "Log In",
              onPressed: () {},
            ),

            // link to signup page
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Signup(),
                  ),
                );
              },
              child: Text(
                "Don't have an account? Sign up!",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

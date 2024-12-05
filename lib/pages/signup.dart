import 'package:firebase_auth/firebase_auth.dart';
import 'package:flirtify/components/my_elevated_button.dart';
import 'package:flirtify/components/my_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwRepeatController = TextEditingController();

  bool _signupFailed = false;
  String _errorMessage = "";

  void handleSignUp() async {
    try {
      if (_pwController.text == _pwRepeatController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _pwController.text,
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _signupFailed = true;
          _errorMessage = "Passwords don't match!";
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          _signupFailed = true;
          _errorMessage = 'Password is too weak!';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          _signupFailed = true;
          _errorMessage = 'Email is already in use!';
        });
      } else {
        setState(() {
          _signupFailed = true;
          _errorMessage = "Error: ${e.message}";
        });
      }
    } catch (e) {
      _signupFailed = true;
      _errorMessage = 'An error occured: $e';
    }
  }

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
              controller: _emailController,
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              hint: "Password",
              obscureText: true,
              controller: _pwController,
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              hint: "Repeat Password",
              obscureText: true,
              controller: _pwRepeatController,
            ),

            // show error if there is one
            signUpErrorIfNeeded(context),

            // submit button
            SizedBox(
              height: 15,
            ),
            MyElevatedButton(
              text: "Sign Up",
              onPressed: handleSignUp,
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

  Widget signUpErrorIfNeeded(BuildContext context) {
    if (_signupFailed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flirtify/components/my_elevated_button.dart';
import 'package:flirtify/components/my_text_field.dart';
import 'package:flirtify/pages/signup.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  bool loginFailed = false;

  void handleLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: pwController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        loginFailed = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // basic message
            const Text("Welcome back! Sign in to continue flirting."),

            // fields
            const SizedBox(
              height: 15,
            ),
            MyTextField(
              hint: "Email",
              controller: emailController,
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              hint: "Password",
              controller: pwController,
            ),

            // error if needed
            signInErrorIfNeeded(context),

            // submit button
            const SizedBox(
              height: 15,
            ),
            MyElevatedButton(
              text: "Log In",
              onPressed: handleLogin, // TODO:
            ),

            // link to signup page
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Signup(),
                  ),
                );
              },
              child: const Text(
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

  Widget signInErrorIfNeeded(BuildContext context) {
    if (loginFailed) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            "Username or password incorrect!",
            style: const TextStyle(color: Colors.red),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

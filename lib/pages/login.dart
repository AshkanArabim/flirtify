import 'package:firebase_auth/firebase_auth.dart';
import 'package:flirtify/components/my_elevated_button.dart';
import 'package:flirtify/components/my_text_field.dart';
import 'package:flirtify/pages/signup.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  bool _loginFailed = false;
  String _errorMessage = "";

  void handleLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _pwController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        setState(() {
          _loginFailed = true;
          _errorMessage = "Username or password incorrect!";
        });
      } else {
        setState(() {
          _loginFailed = true;
          _errorMessage = "Error: ${e.code}";
        });
      }
    } catch (e) {
      setState(() {
        _loginFailed = true;
        _errorMessage = "Error $e";
      });
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
              controller: _emailController,
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              hint: "Password",
              controller: _pwController,
              obscureText: true,
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
                    builder: (_) => const SignupPage(),
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
    if (_loginFailed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

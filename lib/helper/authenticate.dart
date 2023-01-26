import 'package:chatogether/pages/auth/sign_in.dart';
import 'package:chatogether/pages/dashboard/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  Authenticate({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return const Home();
    } else {
      return const SignIn();
    }
  }
}

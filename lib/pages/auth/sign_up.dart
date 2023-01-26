// ignore_for_file: library_private_types_in_public_api

import 'package:chatogether/helper/auth_method.dart';
import 'package:chatogether/pages/auth/sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Create Account!',
                style:
                    TextStyle(color: Theme.of(context).cardColor, fontSize: 33),
              ),
              const SizedBox(
                height: 60,
              ),
              _nameTextField(),
              const SizedBox(
                height: 30,
              ),
              _emailTextField(),
              const SizedBox(
                height: 30,
              ),
              _passwordTextField(),
              const SizedBox(
                height: 40,
              ),
              _button(),
              const SizedBox(
                height: 40,
              ),
              _options(),
              const SizedBox(
                height: 15,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  _nameTextField() {
    return TextField(
      controller: _name,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).cardColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).cardColor),
        ),
        hintText: 'Enter name',
        hintStyle: TextStyle(color: Theme.of(context).cardColor),
      ),
    );
  }

  _emailTextField() {
    return TextField(
      controller: _email,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).cardColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).cardColor),
        ),
        hintText: 'Enter email-ID',
        hintStyle: TextStyle(color: Theme.of(context).cardColor),
      ),
    );
  }

  _passwordTextField() {
    return TextField(
      controller: _password,
      obscureText: true,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).cardColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).cardColor),
        ),
        hintText: 'Enter password',
        hintStyle: TextStyle(color: Theme.of(context).cardColor),
      ),
    );
    ;
  }

  _button() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        'SignUp',
        style: TextStyle(
          color: Theme.of(context).cardColor,
          fontSize: 27,
          fontWeight: FontWeight.w700,
        ),
      ),
      CircleAvatar(
        radius: 30,
        backgroundColor: Color.fromARGB(255, 28, 42, 79),
        child: IconButton(
          color: Theme.of(context).cardColor,
          onPressed: () {
            if (_name.text.isNotEmpty &&
                _email.text.isNotEmpty &&
                _password.text.isNotEmpty) {
              setState(() {
                isLoading = true;
              });
              createAccount(_name.text, _email.text, _password.text)
                  .then((user) {
                if (user != null) {
                  setState(() {
                    isLoading = false;
                  });
                  if (kDebugMode) {
                    print("Account created successfully :)");
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  if (kDebugMode) {
                    print("Account creation failed :(");
                  }
                }
              });
            } else {
              if (kDebugMode) {
                print("Please enter fields first!");
              }
            }
          },
          icon: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
    ]);
  }

  _options() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        },
        child: Text(
          'SignIn',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 18,
            color: Theme.of(context).cardColor,
          ),
        ),
      ),
    ]);
  }
}

import 'package:chatogether/helper/auth_method.dart';
import 'package:chatogether/pages/auth/forgot_password.dart';
import 'package:chatogether/pages/auth/sign_up.dart';
import 'package:chatogether/pages/dashboard/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
                'Welcome Back',
                style: TextStyle(
                    color: Theme.of(context).iconTheme.color, fontSize: 33),
              ),
              const SizedBox(
                height: 60,
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
            ]),
          ),
        ),
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
  }

  _button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SignIn',
          style: TextStyle(
            color: Theme.of(context).cardColor,
            fontSize: 27,
            fontWeight: FontWeight.w700,
          ),
        ),
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color.fromARGB(255, 28, 42, 79),
          child: IconButton(
            color: Theme.of(context).cardColor,
            onPressed: () {
              if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
                setState(() {
                  isLoading = true;
                });
                logIn(_email.text, _password.text).then((user) {
                  if (user != null) {
                    setState(() {
                      isLoading = false;
                    });
                    if (kDebugMode) {
                      print("LoggedIn successfully :)");
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    if (kDebugMode) {
                      print("Login failed :(");
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
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
          ),
        ),
      ],
    );
  }

  _options() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUp()),
          );
        },
        child: Text(
          'SignUp',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 18,
            color: Theme.of(context).cardColor,
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPassword()),
          );
        },
        child: Text(
          'Forgot Password',
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

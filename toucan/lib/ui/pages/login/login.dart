import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Toucan',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              isSignIn ? buildSignInForm() : buildRegisterForm(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement your authentication logic here
                },
                child: Text(isSignIn ? 'Sign In' : 'Register'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    isSignIn = !isSignIn;
                  });
                },
                child: Text(isSignIn
                    ? 'Don\'t have an account? Register'
                    : 'Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignInForm() {
    return const Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Username'),
        ),
        SizedBox(height: 10),
        TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password'),
        ),
      ],
    );
  }

  Widget buildRegisterForm() {
    return const Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Username'),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(height: 10),
        TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password'),
        ),
        SizedBox(height: 10),
        TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Confirm Password'),
        ),
      ],
    );
  }
}

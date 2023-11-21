import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:toucan/ui/pages/order/order.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
              const SizedBox(height: 20),
              SizedBox(
                height: 125,
                child: SvgPicture.asset(
                  'images/svg/logo.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              ),
              const SizedBox(height: 40),
              isSignIn ? buildSignInForm() : buildRegisterForm(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  authenticate();
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
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Username'),
          controller: usernameController,
        ),
        const SizedBox(height: 10),
        TextField(
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
          controller: passwordController,
        ),
      ],
    );
  }

  Widget buildRegisterForm() {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Username'),
          controller: usernameController,
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(labelText: 'Email'),
          controller: emailController,
        ),
        const SizedBox(height: 10),
        TextField(
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
          controller: passwordController,
        ),
        const SizedBox(height: 10),
        TextField(
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Confirm Password'),
          controller: confirmPasswordController,
        ),
      ],
    );
  }

  Future<void> authenticate() async {
    const String baseUrl = 'http://35.205.19.65:4000/';

    final String endpoint = isSignIn ? 'api/users/login' : 'api/users/register';

    final Map<String, String> data = {
      'name': usernameController.text,
      'password': passwordController.text,
    };
    if (!isSignIn) {
      data['email'] = emailController.text;
      data['confirmPassword'] = confirmPasswordController.text;
    }

    final client = http.Client();

    try {
      final response = await client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        redirect();
        print('Authentication successful');
      } else if (response.statusCode == 400) {
        print('Bad Request. Response body: ${response.body}');
      } else {
        print('Authentication failed, ${response.statusCode}');
      }
    } catch (e) {
      print('Error during authentication: $e');
    } finally {
      client.close();
    }
  }

  void redirect() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const OrderScreen(), // Replace 'NewPage' with the actual widget for the new page
      ),
    );
  }
}

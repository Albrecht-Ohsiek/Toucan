import 'package:flutter/material.dart';
import 'package:toucan/ui/pages/login/login.dart';

class MainApp extends StatelessWidget {
  const MainApp ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toucan',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const AuthScreen()
    );
  }
}
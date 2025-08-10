import 'package:flutter/material.dart';
import 'package:mini_app/user_credit.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Registration Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('User Registration Demo')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: RegisterUserWidget(),
        ),
      ),
    );
  }
}

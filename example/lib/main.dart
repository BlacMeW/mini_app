import 'package:flutter/material.dart';
import 'package:mini_app/user_credit.dart';
import 'dart:math';

void main() => runApp(const DemoApp());

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  final GlobalKey<RegisterUserWidgetState> userKey =
      GlobalKey<RegisterUserWidgetState>();
  final TextEditingController addUserNameController = TextEditingController();
  final TextEditingController addUserCreditController = TextEditingController();
  final TextEditingController addCreditIndexController =
      TextEditingController();
  final TextEditingController addCreditValueController =
      TextEditingController();
  final TextEditingController getUserIdController = TextEditingController();
  String userInfoResult = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Registration Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('User Registration Demo')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Mini App Function',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              // UI to call addUser
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: addUserNameController,
                      decoration: const InputDecoration(
                        labelText: 'Add User Name',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: addUserCreditController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Credit'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final name = addUserNameController.text.trim();
                      final credit =
                          int.tryParse(addUserCreditController.text) ?? 0;
                      if (name.isNotEmpty) {
                        final random = Random();
                        final randomUserId =
                            1000 +
                            random.nextInt(9000); // Random ID between 1000-9999
                        userKey.currentState?.addUser(
                          User(
                            name: name,
                            userid: randomUserId,
                            creditPoints: credit,
                          ),
                        );
                        addUserNameController.clear();
                        addUserCreditController.clear();
                      }
                    },
                    child: const Text('Add User'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // UI to call _addCreditPoint
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: addCreditIndexController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'User #'),
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: addCreditValueController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Points'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final idx =
                          int.tryParse(addCreditIndexController.text) ?? -1;
                      final val =
                          int.tryParse(addCreditValueController.text) ?? 0;
                      if (idx >= 0 && val > 0 && userKey.currentState != null) {
                        final users = userKey.currentState!.users;
                        if (idx < users.length) {
                          userKey.currentState!.creditController.text = val
                              .toString();
                          userKey.currentState!.addCreditPoint(idx);
                        }
                        addCreditIndexController.clear();
                        addCreditValueController.clear();
                      }
                    },
                    child: const Text('Add Credit'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // UI to get user by ID
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: getUserIdController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'User ID'),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final userId =
                          int.tryParse(getUserIdController.text) ?? -1;
                      if (userId > 0 && userKey.currentState != null) {
                        final user = userKey.currentState!.getUserInfoByUserId(
                          userId,
                        );
                        setState(() {
                          if (user != null) {
                            userInfoResult =
                                'Found: ${user.name} (ID: ${user.userid}) - ${user.creditPoints} points';
                          } else {
                            userInfoResult = 'User with ID $userId not found';
                          }
                        });
                      }
                    },
                    child: const Text('Get User Info'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (userInfoResult.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    userInfoResult,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Mini App UI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              Expanded(child: RegisterUserWidget(key: userKey)),
            ],
          ),
        ),
      ),
    );
  }
}

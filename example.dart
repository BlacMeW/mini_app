import 'package:flutter/material.dart';
import 'package:mini_app/user_credit.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RegisterUserWidgetState> userKey =
        GlobalKey<RegisterUserWidgetState>();
    final TextEditingController addUserNameController = TextEditingController();
    final TextEditingController addUserCreditController =
        TextEditingController();
    final TextEditingController addCreditIndexController =
        TextEditingController();
    final TextEditingController addCreditValueController =
        TextEditingController();

    return MaterialApp(
      title: 'User Registration Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('User Registration Demo')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                        userKey.currentState?.addUser(
                          User(name: name, creditPoints: credit),
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
              Expanded(child: RegisterUserWidget(key: userKey)),
            ],
          ),
        ),
      ),
    );
  }
}

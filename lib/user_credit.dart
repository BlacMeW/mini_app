import 'package:flutter/material.dart';
import 'dart:math';

/// Registers a new user and returns the created User object.
User registerUser(String name, {int creditPoints = 0, int userid = 0}) {
  if (name.trim().isEmpty) {
    throw ArgumentError('User name cannot be empty');
  }
  return User(name: name.trim(), creditPoints: creditPoints, userid: userid);
}

/// Get user info by userid from a list of users - returns null if user not found
User? getUserInfoByUserId(List<User> userList, int userid) {
  try {
    return userList.firstWhere((user) => user.userid == userid);
  } catch (e) {
    return null; // User not found
  }
}

/// User model for registration and credit points
class User {
  final String name;
  final int userid;
  int creditPoints;
  User({required this.name, required this.userid, this.creditPoints = 0});
}

class RegisterUserWidget extends StatefulWidget {
  const RegisterUserWidget({super.key});

  @override
  RegisterUserWidgetState createState() => RegisterUserWidgetState();
}

class RegisterUserWidgetState extends State<RegisterUserWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController creditController = TextEditingController();
  final List<User> _users = <User>[
    User(name: "Alice Johnson", userid: 1, creditPoints: 100),
    User(name: "Bob Smith", userid: 2, creditPoints: 250),
    User(name: "Carol Brown", userid: 3, creditPoints: 75),
    User(name: "David Wilson", userid: 4, creditPoints: 150),
    User(name: "Emma Davis", userid: 5, creditPoints: 320),
  ];

  /// Expose the user list for external access (read-only)
  List<User> get users => List.unmodifiable(_users);

  int get totalCreditPoints =>
      _users.fold<int>(0, (sum, user) => sum + user.creditPoints);

  void _registerUser() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        final random = Random();
        final randomUserId =
            1000 + random.nextInt(9000); // Random ID between 1000-9999
        _users.add(User(name: name, userid: randomUserId));
        _nameController.clear();
      });
    }
  }

  /// Add a user to the list programmatically (with UI update)
  void addUser(User user) {
    setState(() {
      _users.add(user);
    });
  }

  /// Add credit points to a user at [index] using the value in [creditController]
  void addCreditPoint(int index) {
    final credit = int.tryParse(creditController.text) ?? 0;
    if (credit > 0) {
      setState(() {
        _users[index].creditPoints += credit;
        creditController.clear();
      });
    }
  }

  /// Get user info by userid - returns null if user not found
  User? getUserInfoByUserId(int userid) {
    try {
      return _users.firstWhere((user) => user.userid == userid);
    } catch (e) {
      return null; // User not found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Enter user name'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _registerUser,
          child: const Text('Register User'),
        ),
        const SizedBox(height: 16),
        const Text('Users:', style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return Card(
                child: ListTile(
                  title: Text('${user.name} (ID: ${user.userid})'),
                  subtitle: Text('Credit Points: ${user.creditPoints}'),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: creditController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '+Points',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => addCreditPoint(index),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Total Credit Points: $totalCreditPoints',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

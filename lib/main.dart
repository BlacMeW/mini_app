import 'package:flutter/material.dart';

void main() => runApp(MiniApp());

class MiniApp extends StatelessWidget {
  const MiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Mini App', home: RegisterUserScreen());
  }
}

class User {
  String name;
  int creditPoints;
  User({required this.name, this.creditPoints = 0});
}

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final List<User> _users = [];

  int get totalCreditPoints =>
      _users.fold(0, (sum, user) => sum + user.creditPoints);

  void _registerUser() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        _users.add(User(name: name));
        _nameController.clear();
      });
    }
  }

  void _addCreditPoint(int index) {
    final credit = int.tryParse(_creditController.text) ?? 0;
    if (credit > 0) {
      setState(() {
        _users[index].creditPoints += credit;
        _creditController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register User & Credit Points')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Enter user name'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Register User'),
            ),
            SizedBox(height: 16),
            Text('Users:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    child: ListTile(
                      title: Text(user.name),
                      subtitle: Text('Credit Points: ${user.creditPoints}'),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _creditController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '+Points',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _addCreditPoint(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Total Credit Points: $totalCreditPoints',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mini_app/user_credit.dart';
import 'dart:math';
import 'dart:async';

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
  Timer? _tokenRefreshTimer;

  @override
  void initState() {
    super.initState();
    // Start token refresh timer after a short delay to ensure users are loaded
    Timer(Duration(seconds: 3), () {
      _startTokenRefreshTimer();
    });
  }

  @override
  void dispose() {
    _tokenRefreshTimer?.cancel();
    super.dispose();
  }

  void _startTokenRefreshTimer() {
    // Set initial tokens
    refreshOneUserToken();

    // Start 1-hour periodic timer
    _tokenRefreshTimer = Timer.periodic(Duration(hours: 1), (timer) {
      refreshOneUserToken();
    });

    print('Token refresh timer started - tokens will be refreshed every hour');
  }

  void _refreshAllUserTokens() {
    if (userKey.currentState != null) {
      final users = userKey.currentState!.users;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      for (int i = 0; i < users.length; i++) {
        final newToken = _generateJwtToken(users[i].userid, timestamp);
        try {
          users[i].setToken(newToken);
          print(
            'Refreshed token for ${users[i].name} (ID: ${users[i].userid})',
          );
        } catch (e) {
          print('Error refreshing token for ${users[i].name}: $e');
        }
      }

      print('Token refresh completed at ${DateTime.now()}');
    }
  }

  void refreshOneUserToken() {
    if (userKey.currentState != null) {
      final users = userKey.currentState!.users;
      if (users.isNotEmpty) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final newToken = _generateJwtToken(users[0].userid, timestamp);
        try {
          users[0].setToken(newToken);
          print(
            'Refreshed token for user[0]: ${users[0].name} (ID: ${users[0].userid})',
          );
          print('New token: ${newToken.substring(0, 25)}...');
        } catch (e) {
          print('Error refreshing token for user[0] ${users[0].name}: $e');
        }
      } else {
        print('No users available to refresh token for user[0]');
      }
    }
  }

  String _generateJwtToken(int userId, int timestamp) {
    final random = Random();
    final chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    // Generate mock JWT structure: header.payload.signature
    final header = List.generate(
      16,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
    final payload = List.generate(
      24,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
    final signature = List.generate(
      20,
      (index) => chars[random.nextInt(chars.length)],
    ).join();

    return '$header.$payload.$signature.uid$userId.ts$timestamp';
  }

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
              // Token refresh status
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '🔄 Auto Token Refresh: Active (Every 1 hour)\n'
                  '📝 Check console for refresh logs',
                  style: TextStyle(fontSize: 12, color: Colors.green[700]),
                ),
              ),
              // Manual token refresh button for user[0]
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: refreshOneUserToken,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('🔑 Refresh Token for User[0]'),
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

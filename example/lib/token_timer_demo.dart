import 'package:flutter/material.dart';
import 'package:mini_app/user_credit.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(const TokenTimerDemo());

class TokenTimerDemo extends StatefulWidget {
  const TokenTimerDemo({super.key});

  @override
  State<TokenTimerDemo> createState() => _TokenTimerDemoState();
}

class _TokenTimerDemoState extends State<TokenTimerDemo> {
  final GlobalKey<RegisterUserWidgetState> userKey =
      GlobalKey<RegisterUserWidgetState>();
  Timer? _tokenRefreshTimer;
  String _lastRefreshTime = '';
  int _refreshCount = 0;

  @override
  void initState() {
    super.initState();
    // Start token refresh timer with shorter interval for demo (30 seconds)
    Timer(Duration(seconds: 2), () {
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
    _refreshAllUserTokens();

    // Start 30-second periodic timer for demo (change to Duration(hours: 1) for production)
    _tokenRefreshTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _refreshAllUserTokens();
    });

    print(
      '🔄 Token refresh timer started - tokens will be refreshed every 30 seconds (demo mode)',
    );
    print('📝 In production, change to Duration(hours: 1) for hourly refresh');
  }

  void _refreshAllUserTokens() {
    if (userKey.currentState != null) {
      final users = userKey.currentState!.users;
      final now = DateTime.now();
      final timestamp = now.millisecondsSinceEpoch;

      setState(() {
        _refreshCount++;
        _lastRefreshTime =
            '${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      });

      print('\n🔄 === Token Refresh #$_refreshCount at $_lastRefreshTime ===');

      for (int i = 0; i < users.length; i++) {
        final newToken = _generateJwtToken(users[i].userid, timestamp);
        try {
          users[i].setToken(newToken);
          print(
            '✅ Refreshed token for ${users[i].name} (ID: ${users[i].userid})',
          );
          print('   Token: ${newToken.substring(0, 25)}...');
        } catch (e) {
          print('❌ Error refreshing token for ${users[i].name}: $e');
        }
      }

      print('🏁 Token refresh #$_refreshCount completed\n');
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
      title: 'Token Timer Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Auto Token Refresh Demo'),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🔄 Auto Token Refresh Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('⏱️  Refresh Interval: Every 30 seconds (demo)'),
                      Text('🔢  Refreshes Completed: $_refreshCount'),
                      Text(
                        '🕐  Last Refresh: ${_lastRefreshTime.isNotEmpty ? _lastRefreshTime : "Not started"}',
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '📝 Production Note: Change Duration(seconds: 30) to Duration(hours: 1) for hourly refresh',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '👥 Users (tokens refreshed automatically)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(child: RegisterUserWidget(key: userKey)),
            ],
          ),
        ),
      ),
    );
  }
}

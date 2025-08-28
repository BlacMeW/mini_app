import 'dart:async';
import 'dart:math';
import 'lib/user_credit.dart';

void main() {
  print('=== Mini App User Credit Example ===\n');

  // Create some users
  final users = <User>[
    registerUser('Alice Johnson', creditPoints: 100, userid: 1),
    registerUser('Bob Smith', creditPoints: 250, userid: 2),
    registerUser('Carol Brown', creditPoints: 75, userid: 3),
  ];

  print('Initial users:');
  for (final user in users) {
    print(
      '- ${user.name} (ID: ${user.userid}): ${user.creditPoints} points, Token: ${user.hasToken ? "Set" : "None"}',
    );
  }

  // Set initial tokens for users
  print('\n=== Setting initial JWT tokens ===');
  for (int i = 0; i < users.length; i++) {
    final token = generateMockJwtToken();
    users[i].setToken(token);
    print('Set token for ${users[i].name}: ${token.substring(0, 20)}...');
  }

  print('\nUsers after setting tokens:');
  for (final user in users) {
    print(
      '- ${user.name}: Token status = ${user.hasToken ? "Active" : "None"}',
    );
  }

  // Start timer to refresh tokens every hour (for demo, we'll use 10 seconds)
  print('\n=== Starting token refresh timer (every 10 seconds for demo) ===');
  print('In production, this would be every 1 hour using Duration(hours: 1)');

  Timer.periodic(Duration(seconds: 10), (timer) {
    print('\n--- Token refresh at ${DateTime.now()} ---');

    for (final user in users) {
      final newToken = generateMockJwtToken();
      user.setToken(newToken);
      print(
        'Refreshed token for ${user.name}: ${newToken.substring(0, 20)}...',
      );
    }

    // Stop after 3 refreshes for demo
    if (timer.tick >= 3) {
      print('\nDemo completed. Token refresh timer stopped.');
      timer.cancel();
      return;
    }
  });

  // Keep the program running
  print(
    '\nProgram will refresh tokens every 10 seconds (3 times) then exit...\n',
  );
}

/// Generate a mock JWT token for demonstration
String generateMockJwtToken() {
  final random = Random();
  final chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  // Generate mock JWT structure: header.payload.signature
  final header = List.generate(
    20,
    (index) => chars[random.nextInt(chars.length)],
  ).join();
  final payload = List.generate(
    30,
    (index) => chars[random.nextInt(chars.length)],
  ).join();
  final signature = List.generate(
    25,
    (index) => chars[random.nextInt(chars.length)],
  ).join();

  return '$header.$payload.$signature';
}

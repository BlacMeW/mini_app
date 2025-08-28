import 'dart:async';
import 'dart:math';
import 'lib/user_credit.dart';

/// Production example showing setToken with 1-hour timer interval
void main() {
  print('=== Production Token Management Example ===\n');

  // Create users (in real app, these might come from a database)
  final users = <User>[
    registerUser('Production User 1', creditPoints: 500, userid: 101),
    registerUser('Production User 2', creditPoints: 750, userid: 102),
  ];

  print('Initialized ${users.length} users');

  // Set initial tokens
  for (final user in users) {
    final initialToken = fetchTokenFromAuthService(user.userid);
    user.setToken(initialToken);
    print('Set initial token for ${user.name}');
  }

  // Start hourly token refresh timer
  print('\n=== Starting hourly token refresh ===');
  Timer.periodic(Duration(hours: 1), (timer) {
    final now = DateTime.now();
    print('--- Token refresh triggered at ${now.toString()} ---');

    for (final user in users) {
      try {
        final newToken = fetchTokenFromAuthService(user.userid);
        user.setToken(newToken);
        print('✓ Refreshed token for user ${user.userid} (${user.name})');
      } catch (e) {
        print('✗ Failed to refresh token for user ${user.userid}: $e');
      }
    }

    print('Token refresh completed at ${DateTime.now()}');
  });

  print('Token refresh timer started. Tokens will be refreshed every hour.');
  print('Application is running...');

  // In a real application, this would keep running
  // For demo purposes, we'll just show the setup
}

/// Mock function to simulate fetching token from authentication service
/// In production, this would make HTTP requests to your auth server
String fetchTokenFromAuthService(int userId) {
  // Simulate network delay
  // await Future.delayed(Duration(milliseconds: 100));

  // Generate a realistic JWT token structure
  final header = base64Encode('{"alg":"HS256","typ":"JWT"}');
  final payload = base64Encode(
    '{"sub":"$userId","iat":${DateTime.now().millisecondsSinceEpoch ~/ 1000},"exp":${(DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600}}',
  );
  final signature = generateSignature();

  return '$header.$payload.$signature';
}

/// Simple base64 encoding for demo (in production, use dart:convert)
String base64Encode(String input) {
  final bytes = input.codeUnits;
  final chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  String result = '';

  for (int i = 0; i < bytes.length; i += 3) {
    final chunk =
        (bytes[i] << 16) |
        ((i + 1 < bytes.length ? bytes[i + 1] : 0) << 8) |
        (i + 2 < bytes.length ? bytes[i + 2] : 0);

    result += chars[(chunk >> 18) & 63];
    result += chars[(chunk >> 12) & 63];
    result += i + 1 < bytes.length ? chars[(chunk >> 6) & 63] : '=';
    result += i + 2 < bytes.length ? chars[chunk & 63] : '=';
  }

  return result;
}

/// Generate mock signature
String generateSignature() {
  final random = Random();
  final chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  return List.generate(
    43,
    (index) => chars[random.nextInt(chars.length)],
  ).join();
}

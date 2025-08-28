# Mini App User Registration Library

A Flutter library for user registration and credit point management with both programmatic functions and ready-to-use UI widgets.

## Features

- ✅ User registration with random ID generation
- ✅ Credit point management system
- ✅ User search by ID functionality
- ✅ JWT Token management with setToken() function
- ✅ Pre-built Flutter UI widgets
- ✅ Predefined sample users for testing
- ✅ Comprehensive error handling

## Quick Start

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  mini_app:
    git:
      url: https://github.com/BlacMeW/mini_app.git
      ref: main
```

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:mini_app/user_credit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('User Management')),
        body: RegisterUserWidget(), // Ready-to-use widget
      ),
    );
  }
}
```

### Programmatic Usage

```dart
// Create a user
final user = registerUser("John Doe", creditPoints: 100, userid: 1234);

// Set JWT token
user.setToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...");
print('Token set: ${user.hasToken}'); // true

// Search for user
final userList = [/* your users */];
final foundUser = getUserInfoByUserId(userList, 1234);
if (foundUser != null) {
  print('Found: ${foundUser.name}');
  print('Has token: ${foundUser.hasToken}');
}

// Timer-based token refresh (every hour)
Timer.periodic(Duration(hours: 1), (timer) {
  for (final user in userList) {
    final newToken = fetchTokenFromAuthService(user.userid);
    user.setToken(newToken);
  }
});

// Refresh token for specific user (user[0])
void refreshFirstUserToken() {
  if (userList.isNotEmpty) {
    final newToken = fetchTokenFromAuthService(userList[0].userid);
    userList[0].setToken(newToken);
    print('Refreshed token for first user: ${userList[0].name}');
  }
}
```

## Documentation

- 📖 [Complete Developer Guide](DEVELOPER_GUIDE.md) - Comprehensive API documentation
- 🚀 [Example App](example/) - Full implementation example
- 🧪 [Tests](test/) - Unit tests and usage examples

## API Overview

### Core Classes
- `User` - User model with name, userid, creditPoints, and JWT token support
- `RegisterUserWidget` - Complete UI widget for user management

### Functions
- `registerUser()` - Create new users with validation
- `getUserInfoByUserId()` - Search users by ID

### User Methods
- `setToken(String jwtToken)` - Set JWT token for the user
- `get token` - Get the current JWT token
- `get hasToken` - Check if user has a token set

### Widget Methods (via GlobalKey)
- `addUser()` - Add users programmatically
- `addCreditPoint()` - Manage credit points
- `refreshOneUserToken()` - Refresh JWT token for user[0] only
- `getUserInfoByUserId()` - Search within widget
- `users` - Access user list
- `totalCreditPoints` - Get total credits

## Example Features

The included example app demonstrates:

- User registration with random IDs
- External user addition
- Credit point management
- User search functionality
- Error handling patterns

## Requirements

- Flutter SDK: >=1.17.0
- Dart SDK: ^3.8.1

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the project
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

This library provides sample code for JWT token management patterns. For production use, integrate with Firebase Authentication or your preferred authentication service.

### 🔥 Firebase JWT Integration

This mini app is designed to work with **Firebase JWT Tokens** for production environments:

```dart
// Production example with Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_app/user_credit.dart';

Future<void> setFirebaseToken(User user) async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser != null) {
    final idToken = await firebaseUser.getIdToken();
    user.setToken(idToken);
  }
}
```

### ⚠️ Important Note

**The token examples in this library are for demonstration purposes only.** In production:
- Use actual Firebase JWT tokens from Firebase Authentication
- Implement proper token validation and security measures  
- Follow JWT security best practices
- Never log actual token values

For complete documentation and Firebase integration examples, see [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md).

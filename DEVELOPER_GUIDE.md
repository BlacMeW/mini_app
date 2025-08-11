# Mini App User Registration Library - Developer Guide

## Overview

The `mini_app` library provides a comprehensive user registration and credit point management system for Flutter applications. It includes both programmatic functions and ready-to-use UI widgets.

## Features

- User registration with random ID generation
- Credit point management
- User information retrieval by ID
- Pre-built UI widgets
- Predefined sample users

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  mini_app:
    git:
      url: https://github.com/BlacMeW/mini_app.git
      ref: main
```

Then run:
```bash
flutter pub get
flutter pub upgrade
```

## Core Components

### 1. User Model

```dart
class User {
  final String name;
  final int userid;
  int creditPoints;
  
  User({
    required this.name, 
    required this.userid, 
    this.creditPoints = 0
  });
}
```

### 2. Standalone Functions

#### `registerUser(String name, {int creditPoints = 0, int userid = 0})`
Creates a new User object with validation.

**Parameters:**
- `name`: User's name (required, cannot be empty)
- `creditPoints`: Initial credit points (optional, default: 0)
- `userid`: User ID (optional, default: 0)

**Returns:** `User` object

**Example:**
```dart
import 'package:mini_app/user_credit.dart';

final user = registerUser("John Doe", creditPoints: 100, userid: 1234);
```

#### `getUserInfoByUserId(List<User> userList, int userid)`
Searches for a user by ID in a given list.

**Parameters:**
- `userList`: List of users to search in
- `userid`: ID to search for

**Returns:** `User?` (null if not found)

**Example:**
```dart
final userList = [/* your users */];
final user = getUserInfoByUserId(userList, 1234);
if (user != null) {
  print('Found: ${user.name}');
}
```

### 3. RegisterUserWidget

A complete UI widget for user registration and management.

#### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:mini_app/user_credit.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('User Management')),
        body: RegisterUserWidget(),
      ),
    );
  }
}
```

#### Advanced Usage with External Control

```dart
class MyAdvancedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<RegisterUserWidgetState> userKey = 
        GlobalKey<RegisterUserWidgetState>();
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Advanced User Management')),
        body: Column(
          children: [
            // External controls
            ElevatedButton(
              onPressed: () {
                // Add user programmatically
                final user = User(name: "External User", userid: 9999);
                userKey.currentState?.addUser(user);
              },
              child: Text('Add External User'),
            ),
            
            // Main widget
            Expanded(
              child: RegisterUserWidget(key: userKey),
            ),
          ],
        ),
      ),
    );
  }
}
```

## RegisterUserWidgetState Methods

When using a `GlobalKey<RegisterUserWidgetState>`, you can access these methods:

### `addUser(User user)`
Adds a user to the list programmatically with UI update.

```dart
final user = User(name: "New User", userid: 1234, creditPoints: 50);
userKey.currentState?.addUser(user);
```

### `addCreditPoint(int index)`
Adds credit points to a user at the specified index using the widget's credit controller.

```dart
// Set credit amount first
userKey.currentState?.creditController.text = "100";
// Add to user at index 0
userKey.currentState?.addCreditPoint(0);
```

### `getUserInfoByUserId(int userid)`
Searches for a user by ID within the widget's user list.

```dart
final user = userKey.currentState?.getUserInfoByUserId(1234);
if (user != null) {
  print('Found: ${user.name}');
}
```

### `users` (getter)
Returns a read-only list of all users.

```dart
final userList = userKey.currentState?.users ?? [];
print('Total users: ${userList.length}');
```

### `totalCreditPoints` (getter)
Returns the sum of all users' credit points.

```dart
final total = userKey.currentState?.totalCreditPoints ?? 0;
print('Total credits: $total');
```

## Default Users

The widget comes with 5 predefined users:

1. Alice Johnson (ID: 1, 100 points)
2. Bob Smith (ID: 2, 250 points)
3. Carol Brown (ID: 3, 75 points)
4. David Wilson (ID: 4, 150 points)
5. Emma Davis (ID: 5, 320 points)

## Random ID Generation

New users registered through the UI get random IDs between 1000-9999 for better uniqueness.

## Error Handling

### registerUser Function
- Throws `ArgumentError` if name is empty or only whitespace
- Always trim whitespace from names

### getUserInfoByUserId Functions
- Return `null` instead of throwing exceptions when user not found
- Safe to use without try-catch blocks

## Complete Example

See the `/example` directory for a complete implementation showing:

- Basic user registration
- External user addition
- Credit point management
- User search by ID
- Error handling

## API Reference Summary

| Function/Method | Parameters | Returns | Description |
|----------------|------------|---------|-------------|
| `registerUser()` | `String name, {int creditPoints, int userid}` | `User` | Creates new user with validation |
| `getUserInfoByUserId()` | `List<User> userList, int userid` | `User?` | Finds user by ID in list |
| `addUser()` | `User user` | `void` | Adds user to widget (UI method) |
| `addCreditPoint()` | `int index` | `void` | Adds credits to user (UI method) |
| `getUserInfoByUserId()` | `int userid` | `User?` | Finds user by ID (UI method) |
| `users` | - | `List<User>` | Read-only user list (UI getter) |
| `totalCreditPoints` | - | `int` | Sum of all credits (UI getter) |

## Best Practices

1. Always check for null when using `getUserInfoByUserId()`
2. Use `GlobalKey<RegisterUserWidgetState>` for external widget control
3. Validate user input before calling functions
4. Handle empty states gracefully
5. Consider using random IDs for better user identification

## Troubleshooting

### Common Issues

**Widget state is null:**
```dart
// Wrong
userKey.currentState.addUser(user); // May crash

// Correct
userKey.currentState?.addUser(user); // Safe
```

**User not found:**
```dart
// Always check for null
final user = getUserInfoByUserId(userList, 1234);
if (user != null) {
  // Safe to use user
  print(user.name);
} else {
  print('User not found');
}
```

**Import issues:**
```dart
// Make sure to import the library
import 'package:mini_app/user_credit.dart';
```

## Support

For issues or feature requests, please refer to the example implementation in the `/example` directory, which demonstrates all library features and best practices.

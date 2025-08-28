# 📱 Mini App User Registration Library
## 🚀 Developer Guide

> **A comprehensive Flutter library for user registration, credit management, and JWT token handling**

---

## 📋 Table of Contents

- [🎯 Overview](#-overview)
- [✨ Features](#-features)
- [📦 Installation](#-installation)
- [🏗️ Core Architecture](#️-core-architecture)
- [🔐 Authentication & Tokens](#-authentication--tokens)
- [🧩 API Reference](#-api-reference)
- [🎨 UI Components](#-ui-components)
- [📖 Usage Examples](#-usage-examples)
- [⚡ Advanced Features](#-advanced-features)
- [🛠️ Best Practices](#️-best-practices)
- [🐛 Troubleshooting](#-troubleshooting)

---

## 🎯 Overview

The **Mini App User Registration Library** provides a complete solution for user management in Flutter applications. It combines robust programmatic APIs with ready-to-use UI widgets, featuring advanced JWT token management with automatic refresh capabilities.

### 🎪 Key Highlights

- 🔧 **Programmatic & UI APIs** - Use functions directly or integrate UI widgets
- 🔐 **JWT Token Management** - Built-in token storage and automatic refresh
- ⏱️ **Timer-based Refresh** - Automatic hourly token updates
- 🛡️ **Error Handling** - Comprehensive validation and error management
- 📊 **Credit Point System** - User credit tracking and management
- 🎨 **Clean UI Components** - Ready-to-use, customizable widgets

---

## ✨ Features

### 🔑 **Authentication Features**
- JWT token storage and management
- Automatic token refresh with configurable intervals
- Token validation and error handling
- Individual user token refresh capabilities

### 👥 **User Management** 
- User registration with unique ID generation
- User search and retrieval by ID
- Credit point tracking and management
- Predefined sample users for testing

### 🎨 **UI Components**
- Complete registration widget with built-in functionality
- Manual token refresh controls
- Real-time status indicators
- Responsive design elements

### 🛠️ **Developer Tools**
- Comprehensive logging for token operations
- External widget control via GlobalKey
- Flexible configuration options
- Production-ready examples

---

## 📦 Installation

### 1. Add Dependency

```yaml
dependencies:
  mini_app:
    git:
      url: https://github.com/BlacMeW/mini_app.git
      ref: main
```

### 2. Install Package

```bash
flutter pub get
flutter pub upgrade
```

### 3. Import Library

```dart
import 'package:mini_app/user_credit.dart';
```

---

## 🏗️ Core Architecture

### 📊 User Model

```dart
class User {
  final String name;           // User's display name
  final int userid;           // Unique user identifier  
  int creditPoints;           // User's credit balance
  String? _jwtToken;          // Private JWT token storage
  
  User({
    required this.name, 
    required this.userid, 
    this.creditPoints = 0
  });
  
  // Token management methods
  void setToken(String jwtToken);    // Set user's JWT token
  String? get token;                 // Get current token
  bool get hasToken;                 // Check if token exists
}
```

### 🔄 Token Management Flow

```mermaid
graph TD
    A[App Starts] --> B[Initialize Timer]
    B --> C[Set Initial Tokens]
    C --> D[Start 1-Hour Timer]
    D --> E[Automatic Refresh]
    E --> F[Update All User Tokens]
    F --> G[Log Results]
    G --> D
    
    H[Manual Refresh] --> I[Refresh Single User]
    I --> J[Update User[0] Token]
    J --> K[Log Result]
```

---

## 🔐 Authentication & Tokens

### 🎯 setToken Function

The core token management function with comprehensive validation and error handling.

#### **Method Signature**
```dart
void setToken(String jwtToken)
```

#### **Parameters**
- `jwtToken` (String): The JWT token to store (cannot be empty)

#### **Behavior**
- ✅ Validates token is not empty or whitespace-only
- 🔄 Trims whitespace from token
- 💾 Stores token securely in user object
- ❌ Throws `ArgumentError` for invalid tokens

#### **Usage Examples**

##### Basic Usage
```dart
final user = registerUser('John Doe', userid: 1234);

// Set JWT token
user.setToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...');

// Check token status
print('Has token: ${user.hasToken}'); // true
print('Token: ${user.token?.substring(0, 20)}...'); // First 20 chars
```

##### Error Handling
```dart
try {
  user.setToken(''); // Empty token
} catch (e) {
  print('Error: $e'); // ArgumentError: JWT token cannot be empty
}

try {
  user.setToken('   '); // Whitespace only
} catch (e) {
  print('Error: $e'); // ArgumentError: JWT token cannot be empty
}
```

### ⏱️ Automatic Token Refresh

#### **Hourly Refresh System**
```dart
class _DemoAppState extends State<DemoApp> {
  Timer? _tokenRefreshTimer;
  
  void _startTokenRefreshTimer() {
    // Set initial tokens
    _refreshAllUserTokens();
    
    // Start hourly timer
    _tokenRefreshTimer = Timer.periodic(Duration(hours: 1), (timer) {
      _refreshAllUserTokens();
    });
  }
  
  void _refreshAllUserTokens() {
    final users = userKey.currentState!.users;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    for (final user in users) {
      final newToken = _generateJwtToken(user.userid, timestamp);
      try {
        user.setToken(newToken);
        print('✅ Refreshed token for ${user.name}');
      } catch (e) {
        print('❌ Error refreshing token: $e');
      }
    }
  }
}
```

#### **Single User Refresh**
```dart
void refreshOneUserToken() {
  if (userKey.currentState != null) {
    final users = userKey.currentState!.users;
    if (users.isNotEmpty) {
      final newToken = _generateJwtToken(users[0].userid, timestamp);
      try {
        users[0].setToken(newToken);
        print('✅ Refreshed token for user[0]: ${users[0].name}');
      } catch (e) {
        print('❌ Error refreshing token: $e');
      }
    }
  }
}
```

### 🔧 Token Generation

```dart
String _generateJwtToken(int userId, int timestamp) {
  final random = Random();
  final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  
  // Generate realistic JWT structure
  final header = List.generate(16, (i) => chars[random.nextInt(chars.length)]).join();
  final payload = List.generate(24, (i) => chars[random.nextInt(chars.length)]).join();
  final signature = List.generate(20, (i) => chars[random.nextInt(chars.length)]).join();
  
  return '$header.$payload.$signature.uid$userId.ts$timestamp';
}
```

---

## 🧩 API Reference

### 🎯 Core Functions

#### `registerUser()`
Creates a new User object with validation.

```dart
User registerUser(
  String name, {
  int creditPoints = 0,
  int userid = 0
})
```

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `name` | String | ✅ | - | User's display name |
| `creditPoints` | int | ❌ | 0 | Initial credit points |
| `userid` | int | ❌ | 0 | User identifier |

**Returns:** `User` object  
**Throws:** `ArgumentError` if name is empty

#### `getUserInfoByUserId()`
Searches for a user by ID in a list.

```dart
User? getUserInfoByUserId(List<User> userList, int userid)
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `userList` | List\<User> | ✅ | List to search in |
| `userid` | int | ✅ | ID to search for |

**Returns:** `User?` (null if not found)

### 🔐 Token Methods

#### `setToken()`
Sets JWT token for a user with validation.

```dart
void setToken(String jwtToken)
```

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `jwtToken` | String | ✅ | JWT token to store |

**Throws:** `ArgumentError` if token is empty

#### `token` (getter)
Gets the current JWT token.

```dart
String? get token
```

**Returns:** `String?` (null if no token set)

#### `hasToken` (getter)
Checks if user has a token set.

```dart
bool get hasToken
```

**Returns:** `bool` (true if token exists and not empty)

---

## 🎨 UI Components

### 📱 RegisterUserWidget

A complete UI widget for user management with built-in token refresh functionality.

#### **Basic Implementation**
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

#### **Advanced Implementation with Timer**
```dart
class TokenManagedApp extends StatefulWidget {
  @override
  State<TokenManagedApp> createState() => _TokenManagedAppState();
}

class _TokenManagedAppState extends State<TokenManagedApp> {
  final GlobalKey<RegisterUserWidgetState> userKey = GlobalKey();
  Timer? _tokenTimer;
  
  @override
  void initState() {
    super.initState();
    // Start token refresh after 3 seconds
    Timer(Duration(seconds: 3), _startTokenRefresh);
  }
  
  void _startTokenRefresh() {
    _tokenTimer = Timer.periodic(Duration(hours: 1), (timer) {
      _refreshAllTokens();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Token-Managed Users'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            // Token Status Indicator
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    '🔄 Auto Token Refresh: Active (Every 1 hour)',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                ],
              ),
            ),
            
            // Manual Refresh Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: _refreshUserZeroToken,
                icon: Icon(Icons.refresh),
                label: Text('Refresh User[0] Token'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            
            // Main Widget
            Expanded(
              child: RegisterUserWidget(key: userKey),
            ),
          ],
        ),
      ),
    );
  }
  
  void _refreshUserZeroToken() {
    // Manual refresh logic for user[0]
    final users = userKey.currentState?.users;
    if (users != null && users.isNotEmpty) {
      final newToken = _generateToken(users[0].userid);
      users[0].setToken(newToken);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Refreshed token for ${users[0].name}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
```

### 🎛️ Widget State Methods

When using `GlobalKey<RegisterUserWidgetState>`, access these methods:

#### `addUser(User user)`
```dart
final user = User(name: "New User", userid: 1234, creditPoints: 50);
userKey.currentState?.addUser(user);
```

#### `addCreditPoint(int index)`  
```dart
userKey.currentState?.creditController.text = "100";
userKey.currentState?.addCreditPoint(0);
```

#### `getUserInfoByUserId(int userid)`
```dart
final user = userKey.currentState?.getUserInfoByUserId(1234);
```

#### `refreshOneUserToken()`
```dart
userKey.currentState?.refreshOneUserToken();
```

#### Properties
```dart
// Get user list
final users = userKey.currentState?.users ?? [];

// Get total credit points  
final total = userKey.currentState?.totalCreditPoints ?? 0;
```

---

## 📖 Usage Examples

### 🚀 Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:mini_app/user_credit.dart';
import 'dart:async';

void main() => runApp(QuickStartApp());

class QuickStartApp extends StatefulWidget {
  @override
  State<QuickStartApp> createState() => _QuickStartAppState();
}

class _QuickStartAppState extends State<QuickStartApp> {
  @override
  void initState() {
    super.initState();
    _demonstrateTokenUsage();
  }
  
  void _demonstrateTokenUsage() async {
    // Create user
    final user = registerUser('Demo User', userid: 1001, creditPoints: 100);
    
    // Set token
    user.setToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.demo.token');
    
    print('✅ User created: ${user.name}');
    print('🔑 Token set: ${user.hasToken}');
    print('💰 Credits: ${user.creditPoints}');
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Quick Start Demo')),
        body: RegisterUserWidget(),
      ),
    );
  }
}
```

### 🔄 Production Token Management

```dart
class ProductionTokenManager {
  static Timer? _refreshTimer;
  static List<User> _users = [];
  
  static void startTokenManagement(List<User> users) {
    _users = users;
    
    // Set initial tokens
    _refreshAllTokens();
    
    // Start hourly refresh
    _refreshTimer = Timer.periodic(Duration(hours: 1), (timer) {
      _refreshAllTokens();
      print('🔄 Scheduled token refresh completed');
    });
  }
  
  static void _refreshAllTokens() {
    for (final user in _users) {
      try {
        final newToken = _fetchTokenFromService(user.userid);
        user.setToken(newToken);
        print('✅ Token refreshed for user ${user.userid}');
      } catch (e) {
        print('❌ Token refresh failed for user ${user.userid}: $e');
      }
    }
  }
  
  static String _fetchTokenFromService(int userId) {
    // Simulate API call to authentication service
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'production.token.user$userId.ts$timestamp';
  }
  
  static void stopTokenManagement() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}
```

### 🎯 Manual Token Operations

```dart
void demonstrateManualTokenOps() {
  final users = [
    registerUser('Alice', userid: 1),
    registerUser('Bob', userid: 2),
    registerUser('Carol', userid: 3),
  ];
  
  // Set tokens for all users
  for (int i = 0; i < users.length; i++) {
    users[i].setToken('token_for_user_${users[i].userid}');
    print('Token set for ${users[i].name}: ${users[i].hasToken}');
  }
  
  // Refresh token for specific user (user[0])
  final newToken = 'refreshed_token_${DateTime.now().millisecondsSinceEpoch}';
  users[0].setToken(newToken);
  print('🔄 Refreshed token for ${users[0].name}');
  
  // Validate all tokens
  for (final user in users) {
    if (user.hasToken) {
      print('✅ ${user.name} has valid token');
    } else {
      print('❌ ${user.name} missing token');
    }
  }
}
```

---

## ⚡ Advanced Features

### 🎛️ Custom Token Refresh Intervals

```dart
class CustomIntervalManager {
  static Timer? _customTimer;
  
  static void startCustomInterval(Duration interval, List<User> users) {
    _customTimer = Timer.periodic(interval, (timer) {
      _refreshTokens(users);
    });
  }
  
  static void _refreshTokens(List<User> users) {
    users.forEach((user) {
      final customToken = 'custom.${user.userid}.${timer.tick}';
      user.setToken(customToken);
    });
  }
}

// Usage
CustomIntervalManager.startCustomInterval(
  Duration(minutes: 30), // 30-minute intervals
  userList
);
```

### 🔍 Token Analytics

```dart
class TokenAnalytics {
  static Map<String, dynamic> analyzeTokens(List<User> users) {
    final analytics = {
      'totalUsers': users.length,
      'usersWithTokens': users.where((u) => u.hasToken).length,
      'usersWithoutTokens': users.where((u) => !u.hasToken).length,
      'tokenDetails': <Map<String, dynamic>>[],
    };
    
    for (final user in users) {
      analytics['tokenDetails'].add({
        'userId': user.userid,
        'name': user.name,
        'hasToken': user.hasToken,
        'tokenPreview': user.hasToken 
          ? user.token!.substring(0, 10) + '...'
          : 'No token',
      });
    }
    
    return analytics;
  }
}
```

### 🛡️ Token Validation

```dart
class TokenValidator {
  static bool isValidJWT(String token) {
    final parts = token.split('.');
    return parts.length >= 3 && 
           parts.every((part) => part.isNotEmpty);
  }
  
  static bool validateUserToken(User user) {
    if (!user.hasToken) return false;
    return isValidJWT(user.token!);
  }
  
  static List<User> getUsersWithInvalidTokens(List<User> users) {
    return users.where((user) => 
      user.hasToken && !isValidJWT(user.token!)
    ).toList();
  }
}
```

---

## 🛠️ Best Practices

### ✅ Do's

1. **Always validate tokens before setting**
   ```dart
   if (tokenString.isNotEmpty) {
     user.setToken(tokenString);
   }
   ```

2. **Use try-catch for token operations**
   ```dart
   try {
     user.setToken(newToken);
   } catch (e) {
     print('Token error: $e');
   }
   ```

3. **Implement proper timer cleanup**
   ```dart
   @override
   void dispose() {
     _tokenTimer?.cancel();
     super.dispose();
   }
   ```

4. **Check widget state before operations**
   ```dart
   userKey.currentState?.refreshOneUserToken();
   ```

5. **Log token operations for monitoring**
   ```dart
   print('🔄 Token refreshed for ${user.name} at ${DateTime.now()}');
   ```

### ❌ Don'ts

1. **Don't store tokens in plain text logs**
   ```dart
   // Wrong
   print('Token: ${user.token}');
   
   // Correct  
   print('Token set: ${user.hasToken}');
   ```

2. **Don't ignore timer cleanup**
   ```dart
   // Wrong - memory leak
   Timer.periodic(Duration(hours: 1), (timer) {});
   
   // Correct
   _timer = Timer.periodic(Duration(hours: 1), (timer) {});
   // ... later: _timer?.cancel();
   ```

3. **Don't assume widget state exists**
   ```dart
   // Wrong - may crash
   userKey.currentState.addUser(user);
   
   // Correct
   userKey.currentState?.addUser(user);
   ```

### 🎯 Performance Tips

- Use `Duration(hours: 1)` for production token refresh
- Implement exponential backoff for failed token refreshes  
- Cache tokens appropriately to avoid unnecessary API calls
- Use background isolates for heavy token processing

---

## 🐛 Troubleshooting

### 🚨 Common Issues

#### **ArgumentError: JWT token cannot be empty**

```dart
// Problem
user.setToken(''); // Empty string
user.setToken('   '); // Whitespace only

// Solution
if (tokenString.trim().isNotEmpty) {
  user.setToken(tokenString);
} else {
  print('Invalid token provided');
}
```

#### **Widget state is null**

```dart
// Problem
userKey.currentState.addUser(user); // May crash

// Solution  
if (userKey.currentState != null) {
  userKey.currentState!.addUser(user);
} else {
  print('Widget not ready yet');
}
```

#### **Timer not stopping**

```dart
// Problem - timer continues after widget disposal
Timer.periodic(Duration(hours: 1), (timer) {});

// Solution
Timer? _timer;

void startTimer() {
  _timer = Timer.periodic(Duration(hours: 1), (timer) {});
}

@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```

#### **Token refresh failures**

```dart
// Robust token refresh with error handling
void safeTokenRefresh(User user) {
  try {
    final newToken = generateToken(user.userid);
    user.setToken(newToken);
    print('✅ Token refreshed for ${user.name}');
  } catch (e) {
    print('❌ Token refresh failed for ${user.name}: $e');
    // Implement retry logic or fallback
  }
}
```

### 📊 Debug Information

```dart
void debugTokenInfo(List<User> users) {
  print('=== TOKEN DEBUG INFO ===');
  print('Total users: ${users.length}');
  
  users.asMap().forEach((index, user) {
    print('[$index] ${user.name} (ID: ${user.userid})');
    print('    Has token: ${user.hasToken}');
    print('    Credit points: ${user.creditPoints}');
    if (user.hasToken) {
      print('    Token preview: ${user.token!.substring(0, 15)}...');
    }
  });
  
  final withTokens = users.where((u) => u.hasToken).length;
  print('Users with tokens: $withTokens/${users.length}');
  print('========================');
}
```

### 🔧 Development Tools

```dart
class DevelopmentTools {
  static void logTokenOperations(bool enabled) {
    // Enable/disable detailed token logging
  }
  
  static void simulateTokenFailure(User user) {
    // Simulate token refresh failures for testing
  }
  
  static void validateAllTokens(List<User> users) {
    // Validate all user tokens and report issues
  }
}
```

---

## 📞 Support & Resources

### 📖 Additional Resources
- 🎯 [Example Implementation](example/) - Complete working example
- 🔗 [GitHub Repository](https://github.com/BlacMeW/mini_app) - Source code & issues
- 📝 [README](README.md) - Quick start guide

### 🆘 Getting Help

For issues, questions, or feature requests:

1. Check the example implementation in `/example` directory
2. Review this developer guide for best practices  
3. Submit issues on GitHub with detailed reproduction steps

---

## 📋 Important Notes

### ⚠️ **Sample Code Disclaimer**

> **This library contains sample code for demonstration purposes only.** 
> 
> The JWT token generation and management shown in examples are **mock implementations** designed to illustrate the API usage patterns. In production environments, you should:
> 
> - Replace mock token generators with actual authentication service calls
> - Implement proper token validation and security measures
> - Use production-grade JWT libraries for token handling
> - Follow security best practices for token storage and transmission

### 🔥 **Firebase JWT Integration**

This mini app is designed to work with **Firebase JWT Tokens** for production use:

#### **Firebase Authentication Setup**
```dart
// Production Firebase JWT implementation
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTokenManager {
  static Future<void> setUserToken(User user) async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final idToken = await firebaseUser.getIdToken();
        user.setToken(idToken);
        print('✅ Firebase JWT token set for ${user.name}');
      }
    } catch (e) {
      print('❌ Firebase token error: $e');
    }
  }
  
  static Future<void> refreshFirebaseTokens(List<User> users) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      try {
        final idToken = await firebaseUser.getIdToken(true); // Force refresh
        for (final user in users) {
          user.setToken(idToken);
        }
        print('✅ Firebase tokens refreshed for ${users.length} users');
      } catch (e) {
        print('❌ Firebase token refresh error: $e');
      }
    }
  }
}
```

#### **Required Dependencies**
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  mini_app:
    git:
      url: https://github.com/BlacMeW/mini_app.git
      ref: main
```

#### **Firebase Integration Example**
```dart
// Initialize Firebase and set up token management
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _tokenRefreshTimer;
  
  @override
  void initState() {
    super.initState();
    _setupFirebaseTokenRefresh();
  }
  
  void _setupFirebaseTokenRefresh() {
    // Firebase tokens typically expire in 1 hour
    _tokenRefreshTimer = Timer.periodic(Duration(minutes: 50), (timer) {
      FirebaseTokenManager.refreshFirebaseTokens(userList);
    });
  }
}
```

### 🛡️ **Security Considerations**

When implementing with Firebase JWT tokens:

- ✅ **Use Firebase Auth's built-in token refresh mechanism**
- ✅ **Validate tokens on your backend server**
- ✅ **Implement proper error handling for expired tokens**
- ✅ **Use HTTPS for all token transmissions**
- ✅ **Store tokens securely (avoid plain text storage)**
- ❌ **Never log actual token values in production**
- ❌ **Don't use mock token generators in production**

### 📞 **Production Support**

For production implementations with Firebase:

- 📚 [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- 🔗 [Flutter Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup)
- 🛡️ [JWT Security Best Practices](https://auth0.com/blog/a-look-at-the-latest-draft-for-jwt-bcp/)

---

## 📢 Footer: Firebase JWT Token Integration

This mini app is designed to work with Firebase JWT tokens for secure authentication in production environments. The `setToken` function allows you to store the Firebase JWT token in your user model.

### 🔥 Example: Setting Firebase JWT Token

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_app/user_credit.dart';

Future<void> setFirebaseTokenForMiniApp(User user) async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser != null) {
    final idToken = await firebaseUser.getIdToken();
    user.setToken(idToken); // Store Firebase JWT token in mini app user
    print('✅ Firebase JWT token set for ${user.name}');
  }
}
```

> **Note:** Always use real Firebase JWT tokens in production. The setToken function in this library is designed to work seamlessly with Firebase Authentication.

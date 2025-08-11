# Mini App User Registration Library

A Flutter library for user registration and credit point management with both programmatic functions and ready-to-use UI widgets.

## Features

- ✅ User registration with random ID generation
- ✅ Credit point management system
- ✅ User search by ID functionality
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

// Search for user
final userList = [/* your users */];
final foundUser = getUserInfoByUserId(userList, 1234);
if (foundUser != null) {
  print('Found: ${foundUser.name}');
}
```

## Documentation

- 📖 [Complete Developer Guide](DEVELOPER_GUIDE.md) - Comprehensive API documentation
- 🚀 [Example App](example/) - Full implementation example
- 🧪 [Tests](test/) - Unit tests and usage examples

## API Overview

### Core Classes
- `User` - User model with name, userid, and creditPoints
- `RegisterUserWidget` - Complete UI widget for user management

### Functions
- `registerUser()` - Create new users with validation
- `getUserInfoByUserId()` - Search users by ID

### Widget Methods (via GlobalKey)
- `addUser()` - Add users programmatically
- `addCreditPoint()` - Manage credit points
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

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

# flutter_zod

A Zod-inspired validation library for Flutter, providing declarative, schema-based form validation with seamless widget integration.


## Features

- **Declarative Schemas**: Define validation rules with a chainable, Zod-like API.
- **Flutter Integration**: Use `ZodFormField` for real-time form validation in Flutter apps.
- **Type-Safe**: Built with Dart’s strong typing for reliable validation.
- **Extensible**: Supports common validators (email, min, max) with room for custom rules.
- **Lightweight**: Minimal dependencies for fast integration.

## Getting Started

### Prerequisites
- Flutter SDK: `>=3.0.0`
- Dart SDK: `>=2.18.0 <3.0.0`

### Installation

Add `flutter_zod` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_zod: ^0.1.0
```

Run:

```bash
flutter pub get
```

### Usage

#### Basic Example
Create a form field with email validation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_zod/flutter_zod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Flutter Zod Demo")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ZodFormField(
            schema: ZodString()
                .email("Please enter a valid email")
                .min(5, "Email too short")
                .max(50, "Email too long"),
            controller: TextEditingController(),
            decoration: const InputDecoration(labelText: "Email"),
            liveValidation: true,
          ),
        ),
      ),
    );
  }
}
```

#### Validating Data Programmatically
Use schemas outside of forms:

```dart
final schema = ZodString().email("Invalid email");
final result = schema.parse("test@example.com");

if (result.isSuccess) {
  print("Valid email: ${result.data}");
} else {
  print("Error: ${result.errors}");
}
```

## API Overview

### `ZodString`
- `.email(message)`: Validates an email address.
- `.min(length, message)`: Enforces a minimum string length.
- `.max(length, message)`: Enforces a maximum string length.

### `ZodFormField`
- `schema`: The validation schema (e.g., `ZodString`).
- `controller`: A `TextEditingController` for the input.
- `liveValidation`: Enables real-time validation as the user types.
- `decoration`: Customizes the `TextFormField` appearance.

## Roadmap
- Add `ZodNumber`, `ZodObject`, and `ZodArray` schemas.
- Support custom validators with `.refine()`.
- Introduce transformations with `.transform()`.
- Enhance form widgets with animations and multi-field support.

## Contributing
Contributions are welcome! Please:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/awesome-feature`).
3. Commit your changes (`git commit -m 'Add awesome feature'`).
4. Push to the branch (`git push origin feature/awesome-feature`).
5. Open a pull request.

File issues or suggestions on the [GitHub Issues page](https://github.com/shamnad-sherief/flutter_zod/issues).

## License
This project is licensed under the MIT License.

## Contact
- GitHub: [shamnad-sherief](https://github.com/shamnad-sherief)


Happy validating!
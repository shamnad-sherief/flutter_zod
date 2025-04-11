import 'package:flutter/material.dart';
import 'package:flutter_zod/flutter_zod.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ZodFormField(
            schema: ZodString().email("Invalid email"),
            controller: TextEditingController(),
            decoration: const InputDecoration(labelText: "Email"),
            liveValidation: true,
          ),
        ),
      ),
    );
  }
}

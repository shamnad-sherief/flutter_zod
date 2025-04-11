import 'package:flutter_zod/flutter_zod.dart';
import 'package:test/test.dart';

void main() {
  group('ZodString', () {
    test('validates email correctly', () {
      final schema = ZodString().email("Invalid email");
      expect(schema.parse("test@example.com").isSuccess, true);
      expect(schema.parse("invalid").errorMessage, "Invalid email");
    });

    test('enforces min length', () {
      final schema = ZodString().min(5, "Too short");
      expect(schema.parse("hello").isSuccess, true);
      expect(schema.parse("hi").errorMessage, "Too short");
    });
  });
}

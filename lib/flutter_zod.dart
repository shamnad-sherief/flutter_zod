library flutter_zod;

import 'package:flutter/material.dart';

/// Base class for all Zod validation schemas.
///
/// Defines the interface for parsing and validating data of type [T].
/// Subclasses implement specific validation logic (e.g., for strings, numbers).
abstract class ZodBase<T> {
  /// Parses and validates the input [value], returning a [ZodResult].
  ///
  /// Returns [ZodResult.success] with the validated data if valid,
  /// or [ZodResult.failure] with error messages if invalid.
  ZodResult<T> parse(dynamic value);

  /// Optional error message for display in UI.
  ///
  /// Defaults to `null` unless overridden by subclasses.
  String? get errorMessage => null;
}

/// Represents the result of a validation operation.
///
/// Contains either the validated [data] (on success) or a map of [errors] (on failure).
class ZodResult<T> {
  /// Indicates whether the validation was successful.
  final bool isSuccess;

  /// The validated data, if validation succeeded; otherwise, `null`.
  final T? data;

  /// A map of error messages, if validation failed; otherwise, `null`.
  ///
  /// Keys are typically field names or "value" for single-value schemas.
  final Map<String, String>? errors;

  /// Creates a successful result with validated [data].
  ZodResult.success(this.data)
      : isSuccess = true,
        errors = null;

  /// Creates a failed result with a map of [errors].
  ZodResult.failure(this.errors)
      : isSuccess = false,
        data = null;

  /// The first error message, if any, for convenient UI display.
  ///
  /// Returns `null` if there are no errors.
  String? get errorMessage => errors?.values.first;
}

/// A schema for validating strings with chainable rules.
///
/// Supports common validations like email format, minimum length, and maximum length.
/// Example:
/// ```dart
/// final schema = ZodString().email("Invalid email").min(5, "Too short");
/// ```
class ZodString extends ZodBase<String> {
  int? _minLength;
  String? _minMessage;
  int? _maxLength;
  String? _maxMessage;
  String? _emailMessage;
  bool _isEmail = false;

  /// Creates an empty string schema with no validation rules.
  ZodString();

  /// Adds a minimum length validation rule.
  ///
  /// [length]: The minimum allowed string length.
  /// [message]: The error message to display if the rule is violated.
  /// Returns this schema for chaining.
  ZodString min(int length, String message) {
    _minLength = length;
    _minMessage = message;
    return this;
  }

  /// Adds a maximum length validation rule.
  ///
  /// [length]: The maximum allowed string length.
  /// [message]: The error message to display if the rule is violated.
  /// Returns this schema for chaining.
  ZodString max(int length, String message) {
    _maxLength = length;
    _maxMessage = message;
    return this;
  }

  /// Adds an email format validation rule.
  ///
  /// [message]: The error message to display if the input is not a valid email.
  /// Returns this schema for chaining.
  ZodString email(String message) {
    _isEmail = true;
    _emailMessage = message;
    return this;
  }

  @override
  ZodResult<String> parse(dynamic value) {
    if (value is! String) {
      return ZodResult.failure({"value": "Must be a string"});
    }
    if (_minLength != null && value.length < _minLength!) {
      return ZodResult.failure({"value": _minMessage!});
    }
    if (_maxLength != null && value.length > _maxLength!) {
      return ZodResult.failure({"value": _maxMessage!});
    }
    if (_isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return ZodResult.failure({"value": _emailMessage!});
    }
    return ZodResult.success(value);
  }
}

/// A Flutter widget that integrates a [ZodBase] schema with a [TextFormField].
///
/// Provides real-time validation and error display for form inputs.
/// Example:
/// ```dart
/// ZodFormField(
///   schema: ZodString().email("Invalid email"),
///   controller: TextEditingController(),
///   liveValidation: true,
/// )
/// ```
class ZodFormField extends StatefulWidget {
  /// The validation schema to apply to the form field.
  final ZodBase schema;

  /// The controller for the text input.
  final TextEditingController controller;

  /// Optional decoration for the [TextFormField], such as labels or borders.
  final InputDecoration? decoration;

  /// Whether to validate the input in real-time as the user types.
  ///
  /// If `true`, errors update immediately; otherwise, validation occurs on submit.
  final bool liveValidation;

  /// Creates a form field with a validation schema.
  const ZodFormField({
    required this.schema,
    required this.controller,
    this.decoration,
    this.liveValidation = false,
    super.key,
  });

  @override
  State<ZodFormField> createState() => _ZodFormFieldState();
}

class _ZodFormFieldState extends State<ZodFormField> {
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.liveValidation) widget.controller.addListener(_validate);
  }

  void _validate() {
    final result = widget.schema.parse(widget.controller.text);
    setState(() => _error = result.errorMessage);
  }

  @override
  void dispose() {
    if (widget.liveValidation) widget.controller.removeListener(_validate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: (widget.decoration ?? const InputDecoration()).copyWith(
        errorText: _error,
      ),
      validator: (value) => widget.schema.parse(value).errorMessage,
      onChanged: widget.liveValidation ? (_) => _validate() : null,
    );
  }
}

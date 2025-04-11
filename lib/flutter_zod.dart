library flutter_zod;

import 'package:flutter/material.dart';

// Base schema class
abstract class ZodBase<T> {
  ZodResult<T> parse(dynamic value);
  String? get errorMessage => null;
}

// Validation result
class ZodResult<T> {
  final bool isSuccess;
  final T? data;
  final Map<String, String>? errors;

  ZodResult.success(this.data)
      : isSuccess = true,
        errors = null;

  ZodResult.failure(this.errors)
      : isSuccess = false,
        data = null;

  String? get errorMessage => errors?.values.first;
}

// String schema
class ZodString extends ZodBase<String> {
  int? _minLength;
  String? _minMessage;
  int? _maxLength;
  String? _maxMessage;
  String? _emailMessage;
  bool _isEmail = false;

  ZodString();

  ZodString min(int length, String message) {
    _minLength = length;
    _minMessage = message;
    return this;
  }

  ZodString max(int length, String message) {
    _maxLength = length;
    _maxMessage = message;
    return this;
  }

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

// Form field widget
class ZodFormField extends StatefulWidget {
  final ZodBase schema;
  final TextEditingController controller;
  final InputDecoration? decoration;
  final bool liveValidation;

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

import 'package:flutter/material.dart';

class DesignTextField extends StatelessWidget {
  const DesignTextField({
    Key? key,
    required this.label,
    required this.keyboardType,
    required this.textInputAction,
    this.obscureText = false,
    this.enableSuggestions = false,
    this.controller,
    this.isEnabled = true,
    this.errorController,
    this.onChanged,
  }) : super(key: key);
  final String label;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enableSuggestions;
  final TextEditingController? controller;
  final bool isEnabled;
  final ValueNotifier<String?>? errorController;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final errorController = this.errorController;
    if (errorController != null) {
      return ValueListenableBuilder<String?>(
        valueListenable: errorController,
        builder: (_, error, ___) => _TextField(
          obscureText: obscureText,
          enableSuggestions: enableSuggestions,
          label: label,
          isEnabled: isEnabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          controller: controller,
          error: error,
          onChanged: onChanged,
        ),
      );
    }

    return _TextField(
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      label: label,
      isEnabled: isEnabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      controller: controller,
      error: null,
      onChanged: onChanged,
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    Key? key,
    required this.obscureText,
    required this.enableSuggestions,
    required this.label,
    required this.isEnabled,
    required this.keyboardType,
    required this.textInputAction,
    required this.controller,
    required this.error,
    required this.onChanged,
  }) : super(key: key);

  final bool obscureText;
  final bool enableSuggestions;
  final String label;
  final bool isEnabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final String? error;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      decoration: InputDecoration(
        label: Text(label),
        errorText: error,
      ),
      enabled: isEnabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      controller: controller,
      onChanged: onChanged,
    );
  }
}

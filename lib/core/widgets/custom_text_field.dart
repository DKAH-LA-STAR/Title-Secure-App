import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? labelText;
  final String? hint;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextStyle? style;
  final TextStyle? labelStyle;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.labelText,
    this.hint,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.style,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultStyle = TextStyle(color: isDark ? Colors.white : Colors.black);
    final defaultLabelStyle = TextStyle(color: isDark ? const Color(0xFFE5E7EB) : Colors.black87);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: style ?? defaultStyle,
      decoration: InputDecoration(
        labelText: labelText ?? label,
        labelStyle: labelStyle ?? defaultLabelStyle,
        hintText: hintText ?? hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

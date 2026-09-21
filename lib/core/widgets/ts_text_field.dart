import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Dark-themed text input with gold focus border.
///
/// Drop-in replacement for the original [CustomTextField], styled to
/// match the Title Secure design system.
class TsTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool readOnly;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final List<String>? autofillHints;

  const TsTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.readOnly = false,
    this.autofocus = false,
    this.textInputAction,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      maxLength: maxLength,
      readOnly: readOnly,
      autofocus: autofocus,
      textInputAction: textInputAction,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? IconTheme(
                data: const IconThemeData(
                  color: AppColors.textMuted,
                  size: 20,
                ),
                child: prefixIcon!,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconTheme(
                data: const IconThemeData(
                  color: AppColors.textMuted,
                  size: 20,
                ),
                child: suffixIcon!,
              )
            : null,
        counterText: '',
      ),
    );
  }
}

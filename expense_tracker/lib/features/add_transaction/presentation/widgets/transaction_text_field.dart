import 'package:flutter/material.dart';

class TransactionTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? prefixText;

  const TransactionTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hintText,
            prefixText: prefixText,
            filled: true,
            fillColor: theme.colorScheme.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

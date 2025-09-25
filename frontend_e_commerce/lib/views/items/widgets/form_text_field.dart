import 'package:flutter/material.dart';

class FormTextFieldWidget extends StatelessWidget {
  final TextEditingController textController;
  final String label;
  final String? Function(String?)? validator;
  final IconData icon;
  final TextInputType? keyboardType; // optional

  const FormTextFieldWidget({
    super.key,
    required this.textController,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: keyboardType, // only set if not null
      validator: validator,
    );
  }
}

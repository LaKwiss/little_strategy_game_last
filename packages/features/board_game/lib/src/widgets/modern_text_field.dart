import 'package:flutter/material.dart';

class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String errorMessage;
  final TextInputType keyboardType;

  const ModernTextField(
    this.controller,
    this.label,
    this.errorMessage, {
    this.keyboardType = TextInputType.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[800],
        ),
        style: TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMessage;
          }
          if (keyboardType == TextInputType.number &&
              double.tryParse(value) == null) {
            return 'Veuillez entrer un nombre valide';
          }
          return null;
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BuildField extends StatefulWidget {
  const BuildField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.isPassword,
    this.initialValue,
    this.isEnabled,
    super.key,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final String? initialValue;
  final bool? isEnabled;

  @override
  State<BuildField> createState() => _BuildFieldState();
}

class _BuildFieldState extends State<BuildField> {
  Color borderColor = Colors.white.withAlpha((0.5 * 255).toInt());
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        borderColor = _focusNode.hasFocus
            ? Colors.white
            : Colors.white.withAlpha((0.5 * 255).toInt());
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          focusNode: _focusNode,
          onEditingComplete: () => setState(() {
            borderColor = Colors.white.withAlpha((0.5 * 255).toInt());
          }),
          controller: widget.controller,
          initialValue: widget.initialValue,
          enabled: widget.isEnabled,
          obscureText: widget.isPassword,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.surface,
            focusColor: Theme.of(context).colorScheme.surface,
            hoverColor: Theme.of(context).colorScheme.surface,
            labelText: widget.label,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

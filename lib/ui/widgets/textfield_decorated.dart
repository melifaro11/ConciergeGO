import 'package:flutter/material.dart';

/// Text input widget
class TextFieldDecorated extends StatefulWidget {
  /// Input label
  final String? label;

  /// Field controller
  final TextEditingController? controller;

  final bool? obscureText;

  final Widget? suffix;

  final bool? enabled;

  final Function(String)? onSubmitted;

  const TextFieldDecorated(
      {super.key,
      this.label,
      this.controller,
      this.enabled,
      this.obscureText,
      this.suffix,
      this.onSubmitted});

  @override
  State<TextFieldDecorated> createState() => _TextFieldDecoratedState();
}

class _TextFieldDecoratedState extends State<TextFieldDecorated> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.3),
        //     spreadRadius: 2,
        //     blurRadius: 7,
        //     offset: const Offset(5, 5),
        //   ),
        // ],
        borderRadius: BorderRadius.circular(15), // rounded corners
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText ?? false,
        enabled: widget.enabled ?? true,
        onSubmitted: (text) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(text);
          }
        },
        decoration: InputDecoration(
          labelText: widget.label ?? "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          suffix: widget.suffix,
          //filled: true,
          //fillColor: Colors.white,
        ),
      ),
    );
  }
}

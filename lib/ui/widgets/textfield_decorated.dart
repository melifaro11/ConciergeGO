import 'package:flutter/material.dart';

/// Text input widget
class TextFieldDecorated extends StatefulWidget {
  final String? labelText;

  final String? hintText;

  final TextEditingController? controller;

  final bool? obscureText;

  final Widget? suffix;

  final bool? enabled;

  final double? width;

  final double? height;

  final int? maxLines;

  final Function(String)? onSubmitted;

  const TextFieldDecorated({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.enabled,
    this.obscureText,
    this.suffix,
    this.width,
    this.height,
    this.maxLines,
    this.onSubmitted,
  });

  @override
  State<TextFieldDecorated> createState() => _TextFieldDecoratedState();
}

class _TextFieldDecoratedState extends State<TextFieldDecorated> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // rounded corners
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText ?? false,
        enabled: widget.enabled ?? true,
        maxLines: widget.obscureText != null ? 1 : widget.maxLines,
        onSubmitted: (text) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(text);
          }
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          suffix: widget.suffix,
        ),
      ),
    );
  }
}

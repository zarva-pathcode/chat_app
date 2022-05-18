import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/helper/app_text.dart';

class MainTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  const MainTextField({Key? key, this.controller, this.label})
      : super(key: key);

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        label: Text(widget.label!),
        labelStyle: AppText.mainTextStyle.copyWith(
          color: Colors.grey[400],
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: Colors.grey[700]!,
          ),
        ),
      ),
    );
  }
}

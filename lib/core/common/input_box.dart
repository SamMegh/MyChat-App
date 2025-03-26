import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  const InputBox({
  super.key, 
  required this.controller, 
  required this.hintText, 
  this.obscureText=false, 
  this.keyboardType, 
  this.prefixIcon, 
  this.suffixIcon, 
  this.focusNode, 
  this.validator});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      obscureText:obscureText ,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: prefixIcon,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: suffixIcon,
        ),
      ),

    );
  }
}

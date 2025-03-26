import 'package:flutter/material.dart';

class CoustomButton extends StatelessWidget {
  const CoustomButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text("Login"));
  }
}

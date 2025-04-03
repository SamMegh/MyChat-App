import 'package:flutter/material.dart';

class CoustomButton extends StatelessWidget {
  final String? text;
  final Function() onPressed;
  final Widget? child;

  const CoustomButton({super.key, this.text, this.child, required this.onPressed})
    : assert(text != null || child != null, 'Either must be required');
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black87,
        ),
        onPressed: () async {
                  await onPressed.call();
                },
        child: child ?? Text(text!,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 16
        ),),
      ),
    );
  }
}

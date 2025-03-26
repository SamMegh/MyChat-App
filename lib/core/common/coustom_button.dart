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
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black87,
          padding: EdgeInsets.symmetric(vertical: 8),
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

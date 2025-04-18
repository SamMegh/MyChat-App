import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  const ProfileField({required this.label, required this.value, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label :  ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
            decoration: BoxDecoration(
              color: Color.fromRGBO(74, 144, 226, 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(value, style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

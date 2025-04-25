import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});
  @override
  State<StatusPage> createState() => _StatusPage();
}

class _StatusPage extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        elevation: 2,
        title: Text(
          "Status",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      
      body: Center(child: Text("Status Screen will updated soon")));
  }
}

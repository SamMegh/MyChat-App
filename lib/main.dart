import 'package:flutter/material.dart';
import 'package:mychat/core/utils/app_theam_data.dart';
import 'package:mychat/presentation/screens/auth/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: LoginScreen(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:mychat/routes/app_routor.dart';
import 'package:mychat/services/service_locator.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mychat/core/utils/app_theam_data.dart';
import 'package:mychat/presentation/screens/auth/login.dart';

void main() async {
  await setupServicesLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: getIt<AppRoutor>().navgatorKey,
      theme: AppTheme.lightTheme,
      home: LoginScreen(),
    );
  }
}

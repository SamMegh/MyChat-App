import 'package:flutter/material.dart';
import 'package:mychat/logic/cubit/auth_cubit.dart';
import 'package:mychat/presentation/screens/auth/login.dart';
import 'package:mychat/routes/app_routor.dart';
import 'package:mychat/services/service_locator.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await getIt<AuthCubit>().signOut();
              getIt<AppRoutor>().pushAndRemoveUntil(LoginScreen());
            },
          ),
        ],
      ),
      body: const Center(child: Text("you are login")),
    );
  }
}

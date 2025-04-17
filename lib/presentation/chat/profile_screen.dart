import 'package:flutter/material.dart';
import 'package:mychat/widget/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Center(
          child: Text(
            "Profile",
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Center(
             child: ProfilePic(image: "https://i.postimg.cc/cCsYDjvj/user-2.png",
             imageUploadBtnPress: () {},),
           ),
             Text("Ankit",
             style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 30),
             ),

           
          ],
        ),
      ),
    );
  }
}

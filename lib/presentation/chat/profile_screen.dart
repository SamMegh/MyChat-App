import 'package:flutter/material.dart';
import 'package:mychat/repositories/auth_repo.dart';
import 'package:mychat/services/service_locator.dart';
import 'package:mychat/widget/profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthRepo _authRepo;

  @override
  void initState() {
    _authRepo = getIt<AuthRepo>();
    super.initState();
  }


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
        child: Center(
          child: SizedBox(
            width: 430,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ProfilePic(
                    image: "https://i.postimg.cc/cCsYDjvj/user-2.png",
                    imageUploadBtnPress: () {},
                    isShowPhotoUpload: false,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Full Name :  ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(74, 144, 226, 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "ankit megh",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(8),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "User Name :  ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(74, 144, 226, 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Ankit0305",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(8),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email :  ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(74, 144, 226, 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "0305ankitmeghwal@gmail.com",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(8),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Phone Number :  ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(74, 144, 226, 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "9053524416",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(8),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Created At :  ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(74, 144, 226, 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "12-09-2005 4:30 AM",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mychat/logic/cubit/auth/auth_cubit.dart';
import 'package:mychat/model/user_model.dart';
import 'package:mychat/presentation/screens/auth/login.dart';
import 'package:mychat/repositories/auth_repo.dart';
import 'package:mychat/repositories/profile_field.dart';
import 'package:mychat/routes/app_routor.dart';
import 'package:mychat/services/service_locator.dart';
import 'package:mychat/widget/profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthRepo _authRepo;
  late final String _currentUserId;
  UserModel? _profiledata;

  @override
  void initState() {
    super.initState();
    _authRepo = getIt<AuthRepo>();
    _currentUserId = getIt<AuthRepo>().currentUser?.uid ?? "";
    getData();
  }

  void getData() async {
    try {
      _profiledata = await _authRepo.getUserData(_currentUserId);
      setState(() {});
    } catch (e) {
      // handle error e.g., show snackbar
      debugPrint("Error fetching data: $e");
    }
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
      body:
          (_profiledata != null)
              ? SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 430,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child:
                              (_profiledata!.profilePicUrl != "")
                                  ? ProfilePic(
                                    image: _profiledata!.profilePicUrl,
                                    imageUploadBtnPress: () {},
                                    isShowPhotoUpload: false,
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.only(top:32.0),
                                    child: CircleAvatar(
                                      radius: 53 ,
                                      backgroundColor: Color.fromRGBO(
                                        74,
                                        144,
                                        226,
                                        0.3,
                                      ),
                                      foregroundColor: Colors.black,
                                      child: Text(
                                        _profiledata!.fullName
                                            .toString()[0]
                                            .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 53
                                            ),
                                      ),
                                    ),
                                  ),
                        ),
                        SizedBox(height: 30,),
                        ProfileField(
                          label: "Full Name",
                          value: _profiledata!.fullName.toString(),
                        ),
                        ProfileField(
                          label: "User Name",
                          value: _profiledata!.userName.toString(),
                        ),
                        ProfileField(
                          label: "Email",
                          value: _profiledata!.email.toString(),
                        ),
                        ProfileField(
                          label: "Phone Number",
                          value: _profiledata!.phoneNumber.toString(),
                        ),
                        ProfileField(
                          label: "Created At",
                          value:
                              (DateFormat('EEE d/M/y').format(
                                _profiledata!.createdAt.toDate(),
                              )).toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              : Center(child: CircularProgressIndicator()),
      floatingActionButton: TextButton.icon(
        onPressed: () async {
          await getIt<AuthCubit>().signOut();
          getIt<AppRoutor>().pushAndRemoveUntil(LoginScreen());
        },
        label: Text(
          "LogOut",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          ),
        ),
        icon: const Icon(Icons.logout, color: Colors.red),
        iconAlignment: IconAlignment.end,
      ),
    );
  }
}

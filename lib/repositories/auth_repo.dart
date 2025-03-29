import 'dart:math';

import 'package:mychat/model/user_model.dart';
import 'package:mychat/services/base_repo.dart';

class AuthRepo extends BaseRepo {
  Future<UserModel> signUp({
    required String fullName,
    required String userName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw 'Failed to create user';
      }
      final user = UserModel(
        uid: userCredential.user!.uid,
        fullName: fullName,
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
      );
      await saveUserData(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    try {
      firestore.collection("users").doc(user.uid).set(user.toMap());
    } catch (e) {
      throw 'Failed to save user data';
    }
  }
}

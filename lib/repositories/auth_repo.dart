import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:mychat/model/user_model.dart';
import 'package:mychat/services/base_repo.dart';

class AuthRepo extends BaseRepo {
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<UserModel> signUp({
    required String fullName,
    required String userName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      final isemail = await checkEmailExists(email);
      if (isemail) {
        throw 'Email alerady exists';
      }

      final isphone = await checkPhoneExists(phoneNumber);
      if (isphone) {
        throw 'Phone Number alerady exists';
      }

      final isUserName = await checkUserExists(userName);
      if (isUserName) {
        throw 'User Name alerady exists';
      }

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

  Future<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw 'User not found';
      }
      final userData = await getUserData(userCredential.user!.uid);
      return userData;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await firestore.collection("users").doc(uid).get();
      if (!doc.exists) {
        throw 'User data not found';
      }
      return UserModel.formFirestore(doc);
    } catch (e) {
      throw 'Failed to find user data';
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: "dummyByDeveloperForByPassTheError",
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false;
      } else if (e.code == 'wrong-password') {
        return true;
      } else {
        debugPrint('unknown error accure during finding email in database');
        return false;
      }
    }
  }

  Future<bool> checkPhoneExists(String phone) async {
    try {
      final res =
          await firestore
              .collection("users")
              .where("phoneNumber", isEqualTo: phone)
              .get();
      return res.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkUserExists(String userName) async {
    try {
      final res =
          await firestore
              .collection("users")
              .where("userName", isEqualTo: userName)
              .get();
      return res.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

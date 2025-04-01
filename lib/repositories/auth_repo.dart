import 'package:firebase_auth/firebase_auth.dart';
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
      final doc = await firestore.collection("users").doc("uid").get();
      if (!doc.exists) {
        throw 'User data not found';
      }
      return UserModel.formFirestore(doc);
    } catch (e) {
      throw 'Failed to find user data';
    }
  }

  Future<void> signOut() async{
   await auth.signOut();
  }
}

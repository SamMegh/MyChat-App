import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mychat/model/user_model.dart';
import 'package:mychat/services/base_repo.dart';

class ContactRepo extends BaseRepo {
  String get currentUID => FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<bool> requestContactPermission() async {
    return await FlutterContacts.requestPermission();
  }

  Future<List<Map<String, dynamic>>> getRegisteredContact() async {
    try {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      final phoneNumbers =
          contacts
              .where((contact) => contact.phones.isNotEmpty)
              .map(
                (contact) => {
                  'name': contact.displayName,
                  'phoneNumber': contact.phones.first.number.replaceAll(
                    RegExp(r'[^\d+]'),
                    "",
                  ),
                  'photo': contact.photo,
                },
              )
              .toList();

      final usersnapshoot = await firestore.collection("users").get();
      final registeredUsers =
          usersnapshoot.docs
              .map((doc) => UserModel.formFirestore(doc))
              .toList();
      final matchedContact =
          phoneNumbers
              .where((contact) {
                final phoneNumber = contact["phoneNumber"];
                return registeredUsers.any(
                  (user) =>
                      user.phoneNumber == phoneNumber && user.uid != currentUID,
                );
              })
              .map((contact) {
                final registeredUser = registeredUsers.firstWhere(
                  (user) => user.phoneNumber == contact["phoneNumber"],
                  orElse:
                      () => UserModel(
                        uid: "",
                        phoneNumber: "",
                        fullName: "",
                        userName: "",
                        email: "",
                      ),
                );
                return {
                  'id': registeredUser.uid,
                  'name': contact['name'],
                  'PhoneNumber': contact["phoneNumber"],
                };
              })
              .toList();
      print(matchedContact);
      return matchedContact;
    } catch (e) {
      throw 'Failed to fetch Numbers';
    }
  }
}

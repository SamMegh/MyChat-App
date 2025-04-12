import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mychat/model/user_model.dart';
import 'package:mychat/services/base_repo.dart';

class ContactRepo extends BaseRepo {
  String get currentUID => FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<bool> requestContactPermission() async {
    return await FlutterContacts.requestPermission();
  }

  String _cleanPhoneNumber(String number) {
    String cleaned = number.replaceAll(RegExp(r'[^\d+]'), "");
    if (!cleaned.startsWith("+") && cleaned.length == 10) {
      cleaned = "+91$cleaned";
    }

    return cleaned;
  }

  Future<List<Map<String, dynamic>>> getRegisteredContact() async {
    try {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      final phoneNumbers =
          contacts
              .where((contact) => contact.phones.isNotEmpty)
              .map(
                (contact) => {
                  'name': contact.displayName,
                  'phoneNumber': _cleanPhoneNumber(contact.phones.first.number),
                },
              )
              .toSet()
              .toList();
      final usersnapshoot = await firestore.collection("users").get();
      final registeredUsers =
          usersnapshoot.docs
              .map((doc) {
                final user = UserModel.formFirestore(doc);
                user.phoneNumber = _cleanPhoneNumber(
                  user.phoneNumber,
                ); 
                return user;
              })
              .where((user) => user.phoneNumber.isNotEmpty)
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
                  'phoneNumber': contact["phoneNumber"],
                };
              })
              .toList();
      return matchedContact;
    } catch (e) {
      throw 'Failed to fetch Numbers';
    }
  }
}

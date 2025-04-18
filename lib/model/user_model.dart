import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String userName;
  final String email;
  String phoneNumber;
  final bool isOnline;
  final Timestamp lastSeen;
  final Timestamp createdAt;
  final String? fcmToken;
  final List<String> blockedUsers;
  final String profilePicUrl;
  UserModel({
    required this.uid,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    this.isOnline = false,
    Timestamp? lastSeen,
    Timestamp? createdAt,
    this.fcmToken,
    this.blockedUsers = const [],
    this.profilePicUrl='',
  }) : lastSeen = lastSeen ?? Timestamp.now(),
       createdAt = createdAt ?? Timestamp.now();

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? userName,
    String? email,
    String? phoneNumber,
    bool? isOnline,
    Timestamp? lastSeen,
    Timestamp? createdAt,
    String? fcmToken,
    List<String>? blockedUsers,
    String? profilePicUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      fcmToken: fcmToken ?? this.fcmToken,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      profilePicUrl:profilePicUrl??this.profilePicUrl
    );
  }

  factory UserModel.formFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      fullName: data['fullName'] ?? "",
      userName: data['userName'] ?? "",
      email: data['email'] ?? "",
      phoneNumber: data['phoneNumber'] ?? "",
      fcmToken: data['fcmToken'],
      lastSeen: data['lastSeen'] ?? Timestamp.now(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      blockedUsers: List<String>.from(data['blockedUsers']),
      profilePicUrl:data['profilePicUrl']??""
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "fullName": fullName,
      "userName": userName,
      "email": email,
      "phoneNumber": phoneNumber,
      "isOnline": isOnline,
      "lastSeen": lastSeen,
      "createdAt": createdAt,
      "fcmToken": fcmToken,
      "blockedUsers": blockedUsers,
      "profilePicUrl":profilePicUrl
    };
  }
}

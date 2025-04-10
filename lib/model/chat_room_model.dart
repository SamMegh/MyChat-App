import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final List<String> participants;
  final String? lastMessage;
  final Timestamp? lastMessageTime;
  final String? lastMessageSender;
  final Map<String, Timestamp>? lastReadTime;
  final Map<String, String>? participantsName;
  final bool isTyping;
  final String? TypingUser;
  final bool isCallActive;


  ChatRoomModel({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSender,
    Map<String, Timestamp>? lastReadTime,
    Map<String, String>? participantsName,
    this.isTyping = false,
    this.TypingUser,
    this.isCallActive = false,
  }) : lastReadTime = lastReadTime ?? {},
       participantsName = participantsName ?? {};


  factory ChatRoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoomModel(
      id: doc.id,
      participants: List<String>.from(data['participants']),
      lastMessage: data['lastMessage']??"",
      lastMessageSender: data['lastMessageSender']??"",
      lastMessageTime: data['lastMessageTime']??"",
      lastReadTime: Map<String,Timestamp>.from(data['lastReadTime']??{}),
      participantsName: Map<String,String>.from(data["participantsName"]??{}) ,
      isTyping: data['isTyping']??false,
      TypingUser: data['TypingUser'],
      isCallActive: data['isCallActive']??false
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'lastMessageSender': lastMessageSender,
      'lastReadTime': lastReadTime,
      'participantsName': participantsName,
      'isTyping': isTyping,
      'TypingUser': TypingUser,
      'isCallActive': isCallActive,
    };
  }
}

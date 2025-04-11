import 'package:cloud_firestore/cloud_firestore.dart';

enum Messagetype { text, image, video }

enum MessageStatus { sent, read }

class ChatMessage {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String reciverId;
  final String messageContent;
  final Messagetype type;
  final MessageStatus status;
  final Timestamp timestamp;
  final List<String> readBy;
  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.reciverId,
    required this.messageContent,
    this.type = Messagetype.text,
    this.status = MessageStatus.sent,
    required this.timestamp,
    required this.readBy,
  });
  factory ChatMessage.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      chatRoomId: data['chatRoomId'] as String,
      senderId: data['senderId'] as String,
      reciverId: data['reciverId'] as String,
      messageContent: data['messageContent'] as String,
      readBy: List<String>.from(data['readBy'] ?? []),
      type: Messagetype.values.firstWhere(
        (e) => e.toString() == data['type'],
        orElse: () => Messagetype.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => MessageStatus.sent,
      ),
      timestamp: data['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "chatRoomId": chatRoomId,
      "senderId": senderId,
      "reciverId": reciverId,
      "messageContent": messageContent,
      'type': type.toString(),
      'status': status.toString(),
      'timestamp': timestamp,
      'readBy': readBy,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? chatRoomId,
    String? senderId,
    String? reciverId,
    String? messageContent,
    Messagetype? type,
    MessageStatus? status,
    Timestamp? timestamp,
    List<String>? readBy,
  }) {
    return ChatMessage(
      id: id??this.id,
      chatRoomId: chatRoomId??this.chatRoomId,
      senderId: senderId??this.senderId,
      reciverId: reciverId??this.reciverId,
      messageContent: messageContent??this.messageContent,
      timestamp: timestamp??this.timestamp,
      readBy: readBy??this.readBy,
      type: type??this.type,
      status: status??this.status,
    );
  }
}

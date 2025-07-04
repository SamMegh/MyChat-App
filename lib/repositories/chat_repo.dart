import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:mychat/model/chat_message_model.dart';
import 'package:mychat/model/chat_room_model.dart';
import 'package:mychat/model/user_model.dart';
import 'package:mychat/services/base_repo.dart';

class ChatRepo extends BaseRepo {
  CollectionReference get _chatRooms => firestore.collection("chatRooms");
  CollectionReference getChatRoomMessage(String roomId) {
    return _chatRooms.doc(roomId).collection("messages");
  }

  Future<ChatRoomModel> getOrCreateRoom(
    String currentUserId,
    String otherUserId,
  ) async {
    final user = [currentUserId, otherUserId]..sort();
    final roomId = user.join("_");
    final roomDoc = await _chatRooms.doc(roomId).get();
    if (roomDoc.exists) {
      return ChatRoomModel.fromFirestore(roomDoc);
    }
    final currentUserData =
        (await firestore.collection("users").doc(currentUserId).get()).data()
            as Map<String, dynamic>;
    final otherUserData =
        (await firestore.collection("users").doc(otherUserId).get()).data()
            as Map<String, dynamic>;
    final participantsName = {
      currentUserId: currentUserData['fullName']?.toString() ?? "",
      otherUserId: otherUserData['fullName']?.toString() ?? "",
    };
    final newRoom = ChatRoomModel(
      id: roomId,
      participants: user,
      participantsName: participantsName,
      lastReadTime: {
        currentUserId: Timestamp.now(),
        otherUserId: Timestamp.now(),
      },
    );
    await _chatRooms.doc(roomId).set(newRoom.toMap());
    return newRoom;
  }

  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String reciverId,
    required String content,
    bool? isReply,
    String? replyUserId,
    String? replyContent,
    Messagetype type = Messagetype.text,
  }) async {
    final batch = firestore.batch();
    final messageRef = getChatRoomMessage(roomId);
    final messagedoc = messageRef.doc();

    final message = ChatMessage(
      id: messagedoc.id,
      chatRoomId: roomId,
      senderId: senderId,
      reciverId: reciverId,
      messageContent: content,
      timestamp: Timestamp.now(),
      readBy: [senderId],
      isReply: isReply,
      replyUserId: replyUserId,
      replyContent: replyContent

    );
    batch.set(messagedoc, message.toMap());
    batch.update(_chatRooms.doc(roomId), {
      "lastMessage": content,
      'lastMessageSender': senderId,
      'lastMessageTime': message.timestamp,
    });
    await batch.commit();
  }

  Stream<List<ChatMessage>> getMessages(
    String roomId, {
    DocumentSnapshot? lastsnapshot,
  }) {
    var query = getChatRoomMessage(
      roomId,
    ).orderBy('timestamp', descending: true).limit(20);
    if (lastsnapshot != null) {
      query = query.startAfterDocument(lastsnapshot);
    }
    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => ChatMessage.fromFireStore(doc)).toList(),
    );
  }

  Future<List<ChatMessage>> getMoreMessage(
    String roomId, {
    required DocumentSnapshot lastSnapshot,
  }) async {
    final query = getChatRoomMessage(roomId)
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastSnapshot)
        .limit(20);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => ChatMessage.fromFireStore(doc)).toList();
  }

  Stream<List<ChatRoomModel>> getMyChatRooms(String userid) {
    return _chatRooms
        .where("participants", arrayContains: userid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ChatRoomModel.fromFirestore(doc))
                  .toList(),
        );
  }

  Stream<int> getUnreadCount(String roomId, String userId) {
    return getChatRoomMessage(roomId)
        .where('reciverId', isEqualTo: userId)
        .where('status', isEqualTo: MessageStatus.sent.toString())
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> markMessageAsRead(String roomId, String userId) async {
    try {
      final batch = firestore.batch();
      final unreadMessage =
          await getChatRoomMessage(roomId)
              .where("reciverId", isEqualTo: userId)
              .where("status", isEqualTo: MessageStatus.sent.toString())
              .get();
      for (final doc in unreadMessage.docs) {
        batch.update(doc.reference, {
          'readBy': FieldValue.arrayUnion([userId]),
          'status': MessageStatus.read.toString(),
        });
        await batch.commit();
      }
    } catch (e) {
      debugPrint("got an error $e");
    }
  }

  Stream<Map<String, dynamic>> getOnlineUser(String userID) {
    return firestore.collection("users").doc(userID).snapshots().map((
      snapshot,
    ) {
      final data = snapshot.data();
      return {
        "isOnline": data?['isOnline'] ?? false,
        "lastSeen": data?['lastSeen'],
      };
    });
  }

  Future<void> updateUserOnlineStatus(String userID, bool isOnline) async {
    await firestore.collection("users").doc(userID).update({
      "isOnline": isOnline,
      "lastSeen": Timestamp.now(),
    });
  }

  Future<void> updateTypingStatus(
    String roomId,
    String userId,
    bool isTyping,
  ) async {
    try {
      final doc = await _chatRooms.doc(roomId).get();
      if (!doc.exists) {
        debugPrint("error while getting room id for typing ");
        return;
      }
      _chatRooms.doc(roomId).update({
        'isTyping': isTyping,
        'typingUser': isTyping ? userId : null,
      });
    } catch (e) {
      debugPrint("error while update typing in chatrepo $e");
    }
  }

  Stream<Map<String, dynamic>> getTypingStatus(String roomId) {
    return _chatRooms.doc(roomId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return {"isTyping": false, "typingUser": null};
      }
      final data = snapshot.data() as Map<String, dynamic>;
      return {
        "isTyping": data['isTyping'] ?? false,
        "typingUser": data['typingUser'],
      };
    });
  }

  Future<void> blockTheUser(String currentUserId, String receiverId) async {
    final userref = firestore.collection("users").doc(currentUserId);
    await userref.update({
      'blockedUsers': FieldValue.arrayUnion([receiverId]),
    });
  }

  Future<void> unblockTheUser(String currentUserId, String receiverId) async {
    final userref = firestore.collection("users").doc(currentUserId);
    await userref.update({
      'blockedUsers': FieldValue.arrayRemove([receiverId]),
    });
  }

  Stream<bool> isUserBlocked(String currentUserId, String receiverId) {
    return firestore.collection("users").doc(currentUserId).snapshots().map((
      doc,
    ) {
      final userData = UserModel.formFirestore(doc);
      return userData.blockedUsers.contains(receiverId);
    });
  }

  Stream<bool> isAmBlocked(String currentUserId, String receiverId) {
    return firestore.collection("users").doc(receiverId).snapshots().map((
      doc,
    ) {
      final userData = UserModel.formFirestore(doc);
      return userData.blockedUsers.contains(currentUserId);
    });
  }





}

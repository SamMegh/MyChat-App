import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mychat/model/chat_message_model.dart';
import 'package:mychat/model/chat_room_model.dart';
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
    String roomId,
    {DocumentSnapshot? lastsnapshot}
  ) {
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
}

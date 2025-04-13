import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat/logic/cubit/chat/chat_state.dart';
import 'package:mychat/repositories/chat_repo.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo _chatRepo;
  final String currentUserId;
  bool _isInChat = false;
  StreamSubscription? _subMessages;
  StreamSubscription? _subIsOnline;
  StreamSubscription? _subIsTyping;
  ChatCubit({required this.currentUserId, required ChatRepo chatrepo})
    : _chatRepo = chatrepo,
      super(const ChatState());

  void enterChatRoom(String reciverId) async {
    emit(state.copyWith(status: ChatStatus.loading));
    _isInChat = true;
    try {
      final chatroom = await _chatRepo.getOrCreateRoom(
        currentUserId,
        reciverId,
      );
      emit(
        state.copyWith(
          status: ChatStatus.loaded,
          chatRoomId: chatroom.id,
          ricevierId: reciverId,
        ),
      );
      _getMessges(chatroom.id);
      _subToUserTyping(chatroom.id);
      _subToOnlineStatus(reciverId);

      await _chatRepo.updateUserOnlineStatus(currentUserId, true);
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: 'Failed to create chat room $e',
        ),
      );
    }
  }

  void sendMessage({required content}) async {
    if (state.chatRoomId == null) return;
    try {
      await _chatRepo.sendMessage(
        roomId: state.chatRoomId!,
        senderId: currentUserId,
        reciverId: state.ricevierId!,
        content: content,
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: 'Failed to send message $e',
        ),
      );
    }
  }

  void _getMessges(String roomId) {
    _subMessages?.cancel();

    _subMessages = _chatRepo
        .getMessages(roomId)
        .listen(
          (message) {
            if (_isInChat == true) {
              _markAsRead(roomId);
            }
            emit(state.copyWith(message: message, error: null));
          },
          onError: (e) {
            emit(
              state.copyWith(
                error: 'Unable to read messages',
                status: ChatStatus.error,
              ),
            );
          },
        );
  }

  void _markAsRead(String roomId) async {
    try {
      await _chatRepo.markMessageAsRead(roomId, currentUserId);
    } catch (e) {
      debugPrint("error accure in $e");
    }
  }

  Future<void> leaveChat() async {
    _isInChat = false;
  }

  void _subToOnlineStatus(String userId) {
    _subIsOnline?.cancel();
    _subIsOnline = _chatRepo
        .getOnlineUser(userId)
        .listen(
          (status) {
            final isOnline = status['isOnline'] as bool;
            final lastSeen = status['lastSeen'] as Timestamp;
            emit(
              state.copyWith(
                isReceiverOnline: isOnline,
                recevierLastSeen: lastSeen,
              ),
            );
          },
          onError: (e) {
            debugPrint("got an error while getting online status of a user $e");
          },
        );
  }

  void _subToUserTyping(String roomId) {
    _subIsTyping?.cancel();
    _subIsTyping = _chatRepo
        .getTypingStatus(roomId)
        .listen(
          (status) {
            final isTyping = status['isTyping'] as bool;
            final typingUser = status['typingUser'] as String?;
            emit(
              state.copyWith(
                isReceiverTyping: isTyping && typingUser != currentUserId,
              ),
            );
          },
          onError: (e) {
            debugPrint("got an error while getting typing status of a user $e");
          },
        );
  }
}

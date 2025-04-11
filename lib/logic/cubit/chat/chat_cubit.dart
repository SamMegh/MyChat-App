import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat/logic/cubit/chat/chat_state.dart';
import 'package:mychat/repositories/chat_repo.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo _chatRepo;
  final String currentUserId;
  StreamSubscription? _subMessages;
  ChatCubit({required this.currentUserId, required ChatRepo chatrepo})
    : _chatRepo = chatrepo,
      super(const ChatState());

  void enterChatRoom(String reciverId) async {
    emit(state.copyWith(status: ChatStatus.loading));
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
      getMessges(chatroom.id);
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

  void getMessges(String roomId) {
    _subMessages?.cancel();

    _subMessages = _chatRepo
        .getMessages(roomId)
        .listen(
          (message) {
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
}

import 'package:equatable/equatable.dart';
import 'package:mychat/model/chat_message_model.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  final String? ricevierId;
  final String? chatRoomId;
  final String? error;
  final ChatStatus status;
  final List<ChatMessage> message;
  const ChatState({
    this.ricevierId,
    this.chatRoomId,
    this.status = ChatStatus.initial,
    this.error,
    this.message=const[],
  });
  ChatState copyWith({
    String? ricevierId,
    String? chatRoomId,
    String? error,
    ChatStatus? status,
    List<ChatMessage>? message,
  }) {
    return ChatState(
      ricevierId: ricevierId ?? this.ricevierId,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      error: error ?? this.error,
      status: status ?? this.status,
      message: message?? this.message
    );
  }

  @override
  List<Object?> get props => [status, error, ricevierId, chatRoomId, message];
}

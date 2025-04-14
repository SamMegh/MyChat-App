import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:mychat/model/chat_message_model.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  final String? ricevierId;
  final String? chatRoomId;
  final String? error;
  final ChatStatus status;
  final List<ChatMessage> message;
  final bool isReceiverTyping;
  final bool isReceiverOnline;
  final Timestamp? recevierLastSeen;
  final bool hasMoreMessages;
  final bool isLoadMoreMessages;
  final bool isUserBlocked;
  final bool isIBlocked;

  const ChatState({
    this.isReceiverTyping=false, 
    this.isReceiverOnline=false, 
    this.recevierLastSeen, 
    this.hasMoreMessages=true, 
    this.isLoadMoreMessages=false, 
    this.isUserBlocked=false, 
    this.isIBlocked=false, 
    this.ricevierId,
    this.chatRoomId,
    this.status = ChatStatus.initial,
    this.error,
    this.message = const [],
  });
  ChatState copyWith({
    String? ricevierId,
    String? chatRoomId,
    String? error,
    ChatStatus? status,
    List<ChatMessage>? message,
    bool? isReceiverTyping,
    bool? isReceiverOnline,
    Timestamp? recevierLastSeen,
    bool? hasMoreMessages,
    bool? isLoadMoreMessages,
    bool? isUserBlocked,
    bool? isIBlocked,
  }) {
    return ChatState(
      ricevierId: ricevierId ?? this.ricevierId,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      error: error ?? this.error,
      status: status ?? this.status,
      message: message ?? this.message,
      isReceiverTyping: isReceiverTyping??this.isReceiverTyping,
      isReceiverOnline: isReceiverOnline??this.isReceiverOnline,
      recevierLastSeen: recevierLastSeen??this.recevierLastSeen,
      hasMoreMessages: hasMoreMessages??this.hasMoreMessages,
      isLoadMoreMessages: isLoadMoreMessages??this.isLoadMoreMessages,
      isUserBlocked: isUserBlocked??this.isUserBlocked,
      isIBlocked: isIBlocked??this.isIBlocked
    );
  }

  @override
  List<Object?> get props => [status, error, ricevierId, chatRoomId, message, isReceiverTyping, isReceiverOnline, recevierLastSeen, hasMoreMessages, isLoadMoreMessages,isUserBlocked,isIBlocked];
}

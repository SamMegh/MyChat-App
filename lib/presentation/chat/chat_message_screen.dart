import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mychat/logic/cubit/chat/chat_cubit.dart';
import 'package:mychat/logic/cubit/chat/chat_state.dart';
import 'package:mychat/model/chat_message_model.dart';
import 'package:mychat/services/service_locator.dart';

class ChatMessageScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  const ChatMessageScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });
  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreen();
}

class _ChatMessageScreen extends State<ChatMessageScreen> {
  TextEditingController inputTextController = TextEditingController();
  late final ChatCubit _chatCubit;
  @override
  void initState() {
    _chatCubit = getIt<ChatCubit>();
    _chatCubit.enterChatRoom(widget.receiverId);
    super.initState();
  }

  void _handleSendMessage() {
    final content = inputTextController.text.trim();
    if (content == "") return;
    inputTextController.clear();
    _chatCubit.sendMessage(content: content);
  }

  @override
  void dispose() {
    inputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
              child: Text(widget.receiverName[0].toString().toUpperCase()),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiverName, style: TextStyle(fontSize: 16)),
                Text(
                  "Online",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        bloc: _chatCubit,
        builder: (context, state) {
          if (state.status == ChatStatus.error) {
            return Center(child: Text("Unable to load Message"));
          }
          if (state.status == ChatStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: state.message.length,
                  itemBuilder: (context, index) {
                    final message = state.message[index];
                    final isMe = message.senderId == _chatCubit.currentUserId;
                    return MessageBubble(message: message, isMe: isMe);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.emoji_emotions_outlined),
                    ),
                    SizedBox(width: 3),
                    Expanded(
                      child: TextField(
                        controller: inputTextController,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "Message...",
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3),
                    IconButton(
                      onPressed: _handleSendMessage,
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
            ],
          );
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  const MessageBubble({super.key, required this.message, required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 64 : 8,
          right: isMe ? 8 : 46,
          bottom: 4,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isMe
                  ? Theme.of(context).primaryColor.withOpacity(0.4)
                  : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.messageContent, style: TextStyle(fontSize: 16)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('hh:mm a').format(message.timestamp.toDate()), 
                  style: TextStyle(fontSize: 12)),
                SizedBox(width: isMe ? 5 : 0),
                isMe
                    ? Icon(
                      Icons.done_all_rounded,
                      size: 20,
                      color:
                          message.status == MessageStatus.read
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                    )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

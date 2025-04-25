import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mychat/logic/cubit/chat/chat_cubit.dart';
import 'package:mychat/logic/cubit/chat/chat_state.dart';
import 'package:mychat/model/chat_message_model.dart';
import 'package:mychat/services/service_locator.dart';
import 'package:swipe_to/swipe_to.dart';

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
  bool _isComposing = false;
  bool _isReply = false;
  String _replyText = '';
  String _replyUserId = '';
  final _scrollController = ScrollController();

  @override
  void initState() {
    _chatCubit = getIt<ChatCubit>();
    _chatCubit.enterChatRoom(widget.receiverId);
    inputTextController.addListener(_isUserTyping);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _handleSendMessage() {
    final content = inputTextController.text.trim();
    if (content == "") return;
    inputTextController.clear();
    _chatCubit.sendMessage(
      content: content,
      isReply: _isReply,
      replyContent: _replyText,
      replyUserId: _replyUserId,
    );
    setState(() {
      _isReply = false;
      _replyText = '';
      _replyUserId = '';
    });
    _scrollToBottom();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _chatCubit.loadMoreMessages();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _isUserTyping() {
    final isComposing = inputTextController.text.trim().isNotEmpty;
    if (isComposing != _isComposing) {
      setState(() {
        _isComposing = isComposing;
      });
      if (isComposing) {
        _chatCubit.startTyping();
      }
    }
  }

  @override
  void dispose() {
    inputTextController.dispose();
    _scrollController.dispose();
    _chatCubit.leaveChat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color.fromRGBO(74, 144, 226, 0.3),
              child: Text(widget.receiverName[0].toString().toUpperCase()),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiverName, style: TextStyle(fontSize: 16)),
                BlocBuilder<ChatCubit, ChatState>(
                  bloc: _chatCubit,
                  builder: (context, state) {
                    if (state.isReceiverTyping) {
                      return Text(
                        "Typing...",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      );
                    }
                    if (state.isReceiverOnline) {
                      return Text(
                        "Online",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      );
                    }
                    if (state.recevierLastSeen != null) {
                      final lastSeen = state.recevierLastSeen!.toDate();
                      return Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          "Last Seen at ${DateFormat('h:mm a').format(lastSeen)}",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          BlocBuilder<ChatCubit, ChatState>(
            bloc: _chatCubit,
            builder: (context, state) {
              if (state.isUserBlocked) {
                return TextButton.icon(
                  onPressed: () => _chatCubit.unblocUser(widget.receiverId),
                  label: Text("UnBlock"),
                  icon: Icon(Icons.block_outlined),
                );
              }
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_outlined),
                onSelected: (value) async {
                  if (value == "block") {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text(
                              "Are you sure, You want to block ${widget.receiverName}?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Text(
                                  "Block",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                    if (confirm == true) {
                      await _chatCubit.blocUser(widget.receiverId);
                    }
                  }
                },
                itemBuilder:
                    (context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem(
                        value: 'block',
                        child: Text("Block User"),
                      ),
                    ],
              );
            },
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
            return Center(child: CircularProgressIndicator.adaptive());
          }
          return Column(
            children: [
              if (state.isLoadMoreMessages)
                Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator.adaptive(),
                ),
              if (state.isIBlocked)
                Container(
                  padding: EdgeInsets.all(8),
                  color: const Color.fromRGBO(244, 67, 54, 0.1),
                  child: Text(
                    "You Have been blocked",
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  reverse: true,
                  itemCount: state.message.length,
                  itemBuilder: (context, index) {
                    final message = state.message[index];
                    final isMe = message.senderId == _chatCubit.currentUserId;
                    return SizedBox(
                      width: double.infinity,
                      key: ValueKey(message.id),
                      child:
                          isMe
                              ? SwipeTo(
                                onLeftSwipe: (details) {
                                  setState(() {
                                    _isReply = true;
                                    _replyUserId = message.senderId.toString();
                                    _replyText =
                                        message.messageContent.toString();
                                  });
                                },
                                child: MessageBubble(
                                  message: message,
                                  isMe: isMe,
                                  receiverName:widget.receiverName
                                ),
                              )
                              : SwipeTo(
                                onRightSwipe: (details) {
                                  setState(() {
                                    _isReply = true;
                                    _replyUserId = message.senderId.toString();
                                    _replyText =
                                        message.messageContent.toString();
                                  });
                                },
                                child: MessageBubble(
                                  message: message,
                                  isMe: isMe,
                                  receiverName: widget.receiverName,
                                ),
                              ),
                    );
                  },
                ),
              ),
              (state.isIBlocked || state.isUserBlocked)
                  ? Expanded(
                    child: Container(
                      child:
                          state.isIBlocked
                              ? Text(
                                "You are Blocked",
                                textAlign: TextAlign.end,
                              )
                              : Text("You blocked this user"),
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _isReply
                            ? Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade500,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        _replyText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isReply = false;
                                          _replyText = '';
                                          _replyUserId = '';
                                        });
                                      },
                                      icon: const Icon(Icons.close_outlined),
                                      iconSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : const SizedBox(),

                        Row(
                          children: [
                            SizedBox(width: 3),
                            Expanded(
                              child: TextField(
                                onTap: () {},
                                controller: inputTextController,
                                textCapitalization:
                                    TextCapitalization.sentences,
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
  final String receiverName;
  const MessageBubble({super.key, required this.message, required this.isMe, required this.receiverName});
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
              isMe ? Color.fromRGBO(74, 145, 226, 0.211) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:CrossAxisAlignment.center,
                children: [
                  (message.isReply!)
                      ? Container(
                        padding: EdgeInsets.only(left:8, right: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(35, 0, 0, 0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (message.replyUserId ==
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? Text("You",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor
                                ),)
                                : Text(receiverName.toString(),style: TextStyle(
                                  color: Colors.grey
                                ),
                                ),
                            Text(message.replyContent.toString()),
                          ],
                        ),
                      )
                      : SizedBox(),
                  
                ],
              ),
            ),
            Text(message.messageContent, style: TextStyle(fontSize: 16)),
            Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('hh:mm a').format(message.timestamp.toDate()),
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(width: isMe ? 5 : 0),
                  isMe
                      ? Icon(
                        Icons.done_all_rounded,
                        size: 15,
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

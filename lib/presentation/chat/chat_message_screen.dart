import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mychat/model/chat_message_model.dart';

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
      body: Column(
        children: [
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return MessageBubble(message: ChatMessage(
              id: 'msg_001', 
              chatRoomId: 'room_123',
              senderId: 'user_1',
              reciverId: 'user_2', 
              messageContent: 'Hello, how are you?', 
              timestamp: Timestamp.now(), 
              readBy: [], 
              status: MessageStatus.read
            ), 
                
                isMe: false);
              },
            ),
          ),
          Text("hello to chat screen")
        ],
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
      alignment: isMe?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        margin:EdgeInsets.only(
          left: isMe?64:8,
          right: isMe?8:46,
          bottom: 4
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMe?Theme.of(context).primaryColor.withOpacity(0.4):Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            
            Text(message.messageContent,
            style: TextStyle(
              fontSize: 16
            ),),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("19:25",
                style: TextStyle(
                  fontSize: 12
                ),
                ),
                SizedBox(width:isMe? 5:0,),
                isMe?Icon(Icons.done_all_rounded,
                size: 20,
                color: message.status==MessageStatus.read?Theme.of(context).primaryColor:Colors.black87,
                ):SizedBox()
              ],
            ),
          ],
          ),
      ),
    );
  }
}

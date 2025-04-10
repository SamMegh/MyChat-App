import 'package:flutter/material.dart';

class ChatMessageScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  const ChatMessageScreen({super.key,required this.receiverId, required this.receiverName});
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
            CircleAvatar(backgroundColor: Theme.of(context,).primaryColor.withOpacity(0.3),
            child: Text(widget.receiverName[0].toString().toUpperCase(),
            ),
            ),
            SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(widget.receiverName,
              style: TextStyle(
                fontSize: 20,

              ),
              ),
              Text("Online",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green
              ),)
            ],
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:12.0),
            child: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Center(child: Text(widget.receiverName),),
    );
  }
}

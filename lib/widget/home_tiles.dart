import 'package:flutter/material.dart';
import 'package:mychat/model/chat_room_model.dart';
import 'package:mychat/repositories/chat_repo.dart';
import 'package:mychat/services/service_locator.dart';

class HomeTiles extends StatelessWidget {
  final ChatRoomModel chat;
  final String currentUserId;
  final VoidCallback onTap;
  const HomeTiles({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.onTap,
  });

  String _getOtherUserId() {
    final otherUserId = (chat.participants.where(
      (id) => id != currentUserId,
    )).toString().replaceAll("(", "").replaceAll(")", "");
    return chat.participantsName![otherUserId.toString()] ?? "unKnown";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Color.fromRGBO(74, 144, 226, 0.3),
        child: Text(_getOtherUserId()[0].toString().toUpperCase()),
      ),
      title: Text(
        _getOtherUserId().toString(),
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
      ),
      subtitle: Text(
        chat.lastMessage ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),

      trailing: StreamBuilder(
        stream: getIt<ChatRepo>().getUnreadCount(chat.id, currentUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData||snapshot.data==0) {
            return SizedBox();
          }
          return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Text(snapshot.data.toString()),
          );
        },
      ),
    );
  }
}

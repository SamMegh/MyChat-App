import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mychat/presentation/chat/chat_message_screen.dart';
import 'package:mychat/repositories/auth_repo.dart';
import 'package:mychat/repositories/chat_repo.dart';
import 'package:mychat/repositories/contact_repo.dart';
import 'package:mychat/routes/app_routor.dart';
import 'package:mychat/services/service_locator.dart';
import 'package:mychat/widget/home_tiles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ContactRepo _contactRepo;
  late final ChatRepo _chatRepo;
  late final String _currentUserId;

  @override
  void initState() {
    _contactRepo = getIt<ContactRepo>();
    _chatRepo = getIt<ChatRepo>();
    _currentUserId = getIt<AuthRepo>().currentUser?.uid ?? "";
    super.initState();
  }

  void _showContactList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Contacts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              FutureBuilder(
                future: _contactRepo.getRegisteredContact(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                  final contacts = snapshot.data!;
                  if (contacts.isEmpty) {
                    return Center(child: Text("No Contact Found"));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color.fromRGBO(74, 144, 226, 0.3),
                            child: Text(
                              contact['name'][0].toString().toUpperCase(),
                            ),
                          ),
                          title: Text(contact["name"]),
                          onTap: () {
                            getIt<AppRoutor>().push(
                              ChatMessageScreen(
                                receiverId: contact['id'],
                                receiverName: contact['name'],
                              ),
                            );
                          },
                          subtitle: Text(
                            contact['phoneNumber'].toString().replaceAll(
                              "+91",
                              "",
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          "Chats",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      
      body: StreamBuilder(
        stream: _chatRepo.getMyChatRooms(_currentUserId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint("error ${snapshot.error}");
            return Center(
              child: Text("Something went Worong! ${snapshot.error} "),
            );
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          final chats = snapshot.data!;
          if (chats.isEmpty) {
            return Center(child: Text("No Recent Chat Found"));
          }
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return HomeTiles(
                chat: chat,
                currentUserId: _currentUserId,
                onTap: () {
                  final otherUserId = (chat.participants.where(
                    (id) => id != _currentUserId,
                  )).toString().replaceAll("(", "").replaceAll(")", "");
                  final otherUserName =
                      chat.participantsName?[otherUserId] ?? "Unknown";
                  getIt<AppRoutor>().push(ChatMessageScreen(
                    receiverId: otherUserId,
                    receiverName: otherUserName,
                  ));
                },
              );
            },
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final granted = await FlutterContacts.requestPermission();
          if (!mounted) return;
          if (!granted) {
            // Optional: Show custom message or dialog
            messenger.removeCurrentSnackBar();
            messenger.showSnackBar(
              SnackBar(
                content: Text("Permission Denied"),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.black87,
                margin: EdgeInsets.all(8),
              ),
            );
          } else {
            _showContactList(context);
            // Load contacts here
          }
        },
        child: Icon(Icons.chat_outlined, color: Colors.white),
      ),
    );
  }
}

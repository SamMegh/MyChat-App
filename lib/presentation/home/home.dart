import 'package:flutter/material.dart';
import 'package:mychat/logic/cubit/auth_cubit.dart';
import 'package:mychat/presentation/screens/auth/login.dart';
import 'package:mychat/repositories/contact_repo.dart';
import 'package:mychat/routes/app_routor.dart';
import 'package:mychat/services/service_locator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ContactRepo _contactRepo;

  @override
  void initState() {
    _contactRepo = getIt<ContactRepo>();
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
                    return Center(child: CircularProgressIndicator());
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
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
                            child: Text(contact['name'][0].toString().toUpperCase()),
                          ),
                          title: Text(contact["name"]),
                          subtitle: Text(contact['phoneNumber'].toString().replaceAll("+91","")),
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
        title: Text(
          "Chats",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await getIt<AuthCubit>().signOut();
              getIt<AppRoutor>().pushAndRemoveUntil(LoginScreen());
            },
          ),
        ],
      ),
      body: const Center(child: Text("you are login")),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_showContactList(context),
        child: Icon(Icons.chat_outlined, color: Colors.white),
      ),
    );
  }
}

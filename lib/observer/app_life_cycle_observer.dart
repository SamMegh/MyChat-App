import 'package:flutter/material.dart';
import 'package:mychat/repositories/chat_repo.dart';

class AppLifeCycleObserver extends WidgetsBindingObserver {
  final String userId;
  final ChatRepo chatRepo;

  AppLifeCycleObserver({required this.userId, required this.chatRepo});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        print(
          '**************************************************************************************************************************'
        );
        chatRepo.updateUserOnlineStatus(userId, false);
        break;
      case AppLifecycleState.resumed:
        chatRepo.updateUserOnlineStatus(userId, true);
        break; 
      default:
        break;
    }
  }
}

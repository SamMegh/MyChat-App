import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat/logic/cubit/auth_state.dart';
import 'package:mychat/repositories/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  StreamSubscription<User?>? _authStateSubscription;

  AuthCubit({required AuthRepo authrepo})
    : _authRepo = authrepo,
      super(const AuthState()) {
    _init();
  }
  void _init() {
    emit(state.copyWith(status: AuthStatus.initial));
    _authStateSubscription = _authRepo.authStateChanges.listen((user) async {
      if (user != null) {
        try {
          final userData = await _authRepo.getUserData(user.uid);
          emit(state.copyWith(status: AuthStatus.authenticated,user: userData));
        } catch (e) {
          emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
        }
      } else {
        emit(state.copyWith(status: AuthStatus.authenticated));
      }
    });
  }
}

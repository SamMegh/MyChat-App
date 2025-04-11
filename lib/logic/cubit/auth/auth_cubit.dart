import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat/logic/cubit/auth/auth_state.dart';
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
          emit(state.copyWith(status: AuthStatus.loading));
          final userData = await _authRepo.getUserData(user.uid);
          emit(
            state.copyWith(status: AuthStatus.authenticated, user: userData),
          );
        } catch (e) {
          emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
        }
      } else {
        emit(
          state.copyWith(status: AuthStatus.unauthenticated, user: null),
        ); // Fix here
      }
    });
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final user = await _authRepo.logIn(email: email, password: password);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String userName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final user = await _authRepo.signUp(
        fullName: fullName,
        userName: userName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepo.signOut();
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }
}

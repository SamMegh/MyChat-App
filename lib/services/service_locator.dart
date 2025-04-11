import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:mychat/logic/cubit/auth/auth_cubit.dart';
import 'package:mychat/repositories/auth_repo.dart';
import 'package:mychat/repositories/contact_repo.dart';
import 'package:mychat/routes/app_routor.dart';

final getIt = GetIt.instance;
Future<void> setupServicesLocator() async {
  getIt.registerLazySingleton(() => AppRoutor());
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => AuthRepo());
  getIt.registerLazySingleton(() => ContactRepo());
  getIt.registerLazySingleton(()=>AuthCubit(authrepo: AuthRepo()));
}

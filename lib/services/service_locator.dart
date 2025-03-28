import 'package:get_it/get_it.dart';
import 'package:mychat/routes/app_routor.dart';

final getIt = GetIt.instance;
Future<void> setupServicesLocator() async {
  getIt.registerLazySingleton(() => AppRoutor());
}

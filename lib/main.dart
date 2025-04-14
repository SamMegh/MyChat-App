import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychat/logic/cubit/auth/auth_cubit.dart';
import 'package:mychat/logic/cubit/auth/auth_state.dart';
import 'package:mychat/observer/app_life_cycle_observer.dart';
import 'package:mychat/presentation/home/home.dart';
import 'package:mychat/repositories/chat_repo.dart';
import 'package:mychat/routes/app_routor.dart';
import 'package:mychat/services/service_locator.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mychat/core/utils/app_theam_data.dart';
import 'package:mychat/presentation/screens/auth/login.dart';

void main() async {
  // Ensure Flutter bindings are initialized before anything else
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up service locator (getIt) before Firebase
  await setupServicesLocator();
  
  // Initialize Firebase with the provided options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifeCycleObserver _lifeCycleObserver;
  @override
  void initState() {
    getIt<AuthCubit>().stream.listen((state) {
      if (state.status == AuthStatus.authenticated && state.user != null) {
        _lifeCycleObserver = AppLifeCycleObserver(
            userId: state.user!.uid, chatRepo: getIt<ChatRepo>());
      }
      WidgetsBinding.instance.addObserver(_lifeCycleObserver);
    });
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){FocusManager.instance.primaryFocus!.unfocus();},
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: getIt<AppRoutor>().navgatorKey,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthCubit, AuthState>(
            bloc: getIt<AuthCubit>(),
            builder: (context, state) {
              if (state.status == AuthStatus.initial) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator.adaptive()),
                );
              }
              if (state.status == AuthStatus.authenticated) {
                return const Home();
              }
              return const LoginScreen();
            },
          ),
      ),
    );
  }
}

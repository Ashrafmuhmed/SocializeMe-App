import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socializeme_app/Cubits/LoginUserCubit/login_user_cubit.dart';
import 'package:socializeme_app/Cubits/RegesterUserCubit/regester_user_cubit.dart';
import 'Auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => RegesterUserCubit(),
      ),
      BlocProvider(
        create: (context) => LoginUserCubit(),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Auth(),
    ),
  ));
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socializeme_app/screens/MainScreen.dart';
import 'constants/constants.dart';
import 'package:socializeme_app/screens/loginScreen.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  void initState() {
    check();
    super.initState();
  }

  Future<void> check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool logged = prefs.getBool(login_check) ?? false;
    if (logged) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Mainscreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Loginscreen();
  }
}

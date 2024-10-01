import 'package:flutter/material.dart';
import 'package:socializeme_app/models/userData.dart';

import '../widgets/ProfileWidgets/UserProfilePageHead.dart';

class Userprofilepage extends StatefulWidget {
  Userprofilepage({super.key, required this.userData});
    var userData;
  late final Userdata user = Userdata.json(userData: userData);
  @override
  State<Userprofilepage> createState() => _UserprofilepageState();
}

class _UserprofilepageState extends State<Userprofilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [UserProfilePageHead(currentUser: widget.user)],
      ),
    );
  }
}

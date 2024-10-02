import 'package:flutter/material.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/widgets/ProfileWidgets/OtherUserProfilePageHead.dart';


class Userprofilepage extends StatefulWidget {
  Userprofilepage({super.key, required this.user});
   final Userdata user;
  @override
  State<Userprofilepage> createState() => _UserprofilepageState();
}

class _UserprofilepageState extends State<Userprofilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [Otheruserprofilepagehead(currentUser: widget.user)],
      ),
    );
  }
}

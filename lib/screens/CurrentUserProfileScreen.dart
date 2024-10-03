import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/screens/loginScreen.dart';
import '../constants/constants.dart';
import '../widgets/ProfileWidgets/UserProfilePageHead.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final User? _cred = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? currentUserData;
  Userdata? currentUser;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool(login_check, false);
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Loginscreen()));
              },
              icon: const Icon(Icons.output_rounded))
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: FutureBuilder<DocumentSnapshot>(
            future: firestore.collection('profiles').doc(_cred!.uid).get(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                isLoading = false;
                currentUser = Userdata.json(
                    userData: snapshot.data!.data() as Map<String, dynamic>);
                return ListView(
                  children: [UserProfilePageHead(currentUser: currentUser!),
                  
                  ]
                );
              } else {
                isLoading = true;
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.amber,
                ));
              }
            }),
      ),
    );
  }
}

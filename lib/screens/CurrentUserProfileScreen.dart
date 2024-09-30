import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/screens/DeleteAccountPage.dart';
import 'package:socializeme_app/screens/loginScreen.dart';
import 'package:socializeme_app/services/userServices/UserServices.dart';
import '../constants/constants.dart';
import '../widgets/ProfileWidgets/CustomProfileButtonIcons.dart';

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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Loginscreen()));
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
                  children: [
                    Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/pics/WhatsApp Image 2024-09-25 at 17.05.31_61c35a2e.jpg'),
                                        fit: BoxFit.fitHeight)),
                              ),
                              subtitle: Text(
                                currentUser!.bio,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 139, 139, 139)),
                              ),
                              title: Text(
                                currentUser!.username,
                                style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 55),
                              child: Divider(
                                height: 10,
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomProfileButtonIcons(
                                    icondata: Icons.delete_forever_outlined,
                                    onPressed: () {
                                      showPasswordDialog();
                                    },
                                  ),
                                  CustomProfileButtonIcons(
                                    icondata: Icons.edit,
                                    onPressed: () {},
                                  ),
                                  CustomProfileButtonIcons(
                                    icondata: Icons.add_circle_outline,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                );
              } else {
                isLoading = true;
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.amber,
                ));
              }
            }),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to delete the user account
  Future<void> deleteUser(String password) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Re-authenticate the user with their password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        // Re-authenticate
        await user.reauthenticateWithCredential(credential);

        // Delete the user
        await user.delete();

        // Show success message or navigate away
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Your account deleted successfully")),
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Wrong password. Please try again.")),
          );
        } else if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Re-authentication required. Please login again.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.message}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unknown error occurred.")),
        );
      }
    }
  }

  // Function to show the password input dialog
  void showPasswordDialog() {
    final _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String password = _passwordController.text.trim();
                if (password.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  deleteUser(password); // Call the delete function
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Password cannot be empty")),
                  );
                }
              },
              child: Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }
}

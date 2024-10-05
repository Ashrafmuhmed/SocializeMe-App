import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socializeme_app/screens/signupScreen.dart';
import 'package:socializeme_app/widgets/SnackBarWidget.dart';

import '../constants/constants.dart';

class DeleteAccountPage extends StatefulWidget {
    static final String id = 'DeletePage';

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> deleteUser(String password) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        await FirebaseStorage.instance.ref(user.email).delete();
        await FirebaseFirestore.instance
            .collection(profiles)
            .doc(user.uid)
            .delete();
        await user.delete();
        setState(() async {
          isLoading = false;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Signupscreen()));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User account deleted successfully")),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        Snackbarwidget()
            .ShowSnackbar(context: context, message: 'Invalid password');
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unknown error occurred.")),
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
          title: const Text('Enter Password'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String password = _passwordController.text.trim();
                if (password.isNotEmpty) {
                  Navigator.pop(context);
                  setState(() {
                    isLoading = true;
                    deleteUser(password);
                  });
                } else {
                  Snackbarwidget().ShowSnackbar(
                      context: context, message: 'Passwordfield cant be empty');
                }
              },
              child: const Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      blur: 10,
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Delete Account'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'After deleting your account all your data will be deleted permenantly',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 33.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showPasswordDialog();
                      },
                      child: const Text(
                        'Delete my account',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Dont delete my account',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

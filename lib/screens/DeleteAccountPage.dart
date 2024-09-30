import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
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
          SnackBar(content: Text("User account deleted successfully")),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Wrong password. Please try again.")),
          );
        } else if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Re-authentication required. Please login again.")),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showPasswordDialog(); // Show the password input dialog
          },
          child: Text('Delete Account'),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Userservices {
  deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is not null
    if (user != null) {
      try {
        // Re-authenticate the user before deleting
        // Get the user's current authentication credentials
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password:
              'your_user_password_here', // Prompt the user to enter their password
        );

        // Re-authenticate the user
        await user.reauthenticateWithCredential(credential);

        // Now, delete the user
        await user.delete();

        print("User account deleted successfully.");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          // Handle the error, e.g., prompt the user to log in again
          print("Error: ${e.message}");
        }
      } catch (e) {
        print("Unknown error: $e");
      }
    }
  }

  pickImage(ImageSource imgSrc) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: imgSrc);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      log('No message seletcted');
    }
  }
}

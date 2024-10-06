import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Userservices {
  deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: 'your_user_password_here',
        );

        await user.reauthenticateWithCredential(credential);

        await user.delete();

        print("User account deleted successfully.");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
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

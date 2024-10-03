import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:socializeme_app/models/PostModel.dart';

part 'add_post_state.dart';

class AddPostCubit extends Cubit<AddPostState> {
  AddPostCubit() : super(AddPostInitial());
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadImageToStorage(
      {required String childName, required Uint8List file}) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  AddPost(
      {required String title,
      required String description,
      required Uint8List? file}) async {
    Postmodel post = Postmodel(
        title: title,
        description: description,
        time: DateTime.now().toString().substring(0, 16),
        userUid: FirebaseAuth.instance.currentUser!.uid);
    DocumentReference docRef =
        await _firestore.collection('UserPosts').add(post.toJSON());
    String postid = docRef.id;

    String? imgLink;
    if (file != null) {
      imgLink = await uploadImageToStorage(childName: postid, file: file);
      _firestore
          .collection('UserPosts')
          .doc(postid)
          .update({'imgLink': imgLink});
    }

    _firestore
        .collection('profiles')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'postsIds': FieldValue.arrayUnion([postid])
    });
  }
}

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../models/userData.dart';

part 'regester_user_state.dart';

class RegesterUserCubit extends Cubit<RegesterUserState> {
  RegesterUserCubit() : super(RegesterUserInitial());
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  RegesterUser(
      {required String username,
      required String bio,
      required String email,
      required String password}) async {
    emit(RegesterUserLoading());
    log('Regestring user $email');
    try {
      var cred = await register(email, password);
      Userdata user = Userdata(
          bio: bio, email: email, username: username, uid: cred!.user!.uid);
      await _firestore
          .collection('profiles')
          .doc(cred.user!.uid.toString())
          .set(user.toJson());
      log('User regestration completed uid : ${_firestore.collection('profiles').doc(user.uid).get()}');
      emit(RegesterUserSuccess());
    } catch (e) {
      log(e.toString());
      emit(RegesterUserFailure(exception: e as FirebaseAuthException));
    }
  }

  Future<UserCredential?> register(String email, String password) async {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
  }
}

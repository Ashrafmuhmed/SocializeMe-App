import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_user_state.dart';

class LoginUserCubit extends Cubit<LoginUserState> {
  LoginUserCubit() : super(LoginUserInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  LoginUser({required String email, required String password}) async {
    emit(LoginUserLoading());
    log('user $email logging in');
    try {
      var cred = await login(email, password);
      log('User loggedin uid : ${cred!.user!.uid})}');
      emit(LoginUserSuccess());
    } catch (e) {
      log(e.toString());
      emit(LoginUserFailed(exception: e as FirebaseAuthException));
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }
}

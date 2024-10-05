import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socializeme_app/Cubits/LoginUserCubit/login_user_cubit.dart';
import 'package:socializeme_app/models/authModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socializeme_app/widgets/SnackBarWidget.dart';

import '../widgets/CustomTextField.dart';
import 'MainScreen.dart';
import 'signupScreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});
    static final String id = 'LoginScreen';


  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();
  AutovalidateMode autovalid = AutovalidateMode.disabled;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginUserCubit, LoginUserState>(
      listener: (context, state) async {
        if (state is LoginUserFailed) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.exception.message!)));
        } else if (state is LoginUserLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is LoginUserSuccess) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          _isLoading = false;
          Authmodel.isLoggedIn = true;
          Navigator.pop(context);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Mainscreen()));
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return Scaffold(
                body: SafeArea(
                    child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    autovalidateMode: autovalid,
                    key: formkey,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const SizedBox(
                          height: 55,
                        ),
                        Image.asset('assets/pics/Asset 1.png'),
                        CustomTextField(
                          label: 'Email',
                          inputType: TextInputType.emailAddress,
                          controller: _emailCont,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          label: 'Password',
                          inputType: TextInputType.text,
                          secured: true,
                          controller: _passCont,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                BlocProvider.of<LoginUserCubit>(context)
                                    .LoginUser(
                                        email: _emailCont.text,
                                        password: _passCont.text);
                              } else {
                                autovalid = AutovalidateMode.always;
                              }
                            },
                            child: const Text('Login')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account ? '),
                            GestureDetector(
                              onTap: () {
                                navigateSignup(context);
                              },
                              child: const Text(
                                'SignUp',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('forgot your password ? '),
                            GestureDetector(
                              onTap: () {
                                if (_emailCont == '') {
                                  Snackbarwidget().ShowSnackbar(
                                      context: context,
                                      message:
                                          'Write your email in the field first');
                                } else {
                                  FirebaseAuth.instance.sendPasswordResetEmail(
                                      email: _emailCont.text);
                                  Snackbarwidget().ShowSnackbar(
                                      context: context,
                                      message: 'See your mail now !!');
                                }
                              },
                              child: const Text(
                                'Reset my password',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
              );
            }),
      ),
    );
  }

  void navigateSignup(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Signupscreen()));
  }
}

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

          if (state.exception.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No user found for that email')),
            );
          } else if (state.exception.code == 'invalid-email') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid email')),
            );
          } else if (state.exception.code == 'network-request-failed') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No internet connection')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No user found for that email')),
            );
          }
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
                            } else if (!value.contains('@') ||
                                !value.contains('.')) {
                              return 'please enter valid email';
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
                                setState(() {});
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
                                showPasswordDialog();
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

  void showPasswordDialog() {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your email'),
          content: CustomTextField(
            controller: passwordController,
            validator: (p0) {
              return null;
            },
            label: 'Email',
            secured: false,
            inputType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = passwordController.text.trim();
                if (email.isNotEmpty) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.pop(context);
                  });
                  setState(() {
                    passwordController.clear();
                    _isLoading = true;
                  });
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email);
                    setState(() {
                      _isLoading = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('No user found for that email')),
                      );
                    } else if (e.code == 'invalid-email') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid email')),
                      );
                    } else if (e.code == 'network-request-failed') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No internet connection')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No user found for that email')),
                      );
                    }

                    setState(() {
                      _isLoading = false;
                    });
                  }
                } else {
                  Snackbarwidget().ShowSnackbar(
                      context: context, message: 'Email field cant be empty');
                }
              },
              child: const Text('Reset my password'),
            ),
          ],
        );
      },
    );
  }
}

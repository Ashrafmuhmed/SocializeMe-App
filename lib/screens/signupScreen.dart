import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socializeme_app/Cubits/RegesterUserCubit/regester_user_cubit.dart';
import 'package:socializeme_app/screens/CurrentUserProfileScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../models/authModel.dart';
import '../widgets/CustomTextField.dart';
import 'loginScreen.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passCont = TextEditingController();
  final TextEditingController _bioCont = TextEditingController();
  final TextEditingController _nameCont = TextEditingController();
  bool _isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey();
  AutovalidateMode autovalid = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailCont.dispose();
    _passCont.dispose();
    _bioCont.dispose();
    _nameCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegesterUserCubit, RegesterUserState>(
      listener: (context, state) async {
        if (state is RegesterUserLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is RegesterUserFailure) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.exception.message!)),
          );
        } else if (state is RegesterUserSuccess) {
                    Authmodel.isLoggedIn = true;

          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Registered Successfully!')),
          );
              SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          Navigator.pop(context);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Profilescreen()));
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          blur: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              autovalidateMode: autovalid,
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(flex: 2, child: Container()),
                  CustomTextField(
                    label: 'Name',
                    inputType: TextInputType.name,
                    controller: _nameCont,
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
                    label: 'Bio',
                    inputType: TextInputType.text,
                    controller: _bioCont,
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
                    label: 'Email',
                    inputType: TextInputType.emailAddress,
                    controller: _emailCont,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field is required';
                      } else if (!value.contains('@gmail.com')) {
                        return 'Enter valid email';
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
                      } else if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain A , B ,... AND 1 , 2 , 3 , ......';
                      } else if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must contain A , B ,... AND 1 , 2 , 3 , ......';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          formkey.currentState!.save();
                          BlocProvider.of<RegesterUserCubit>(context)
                              .RegesterUser(
                                  username: _nameCont.text,
                                  bio: _bioCont.text,
                                  email: _emailCont.text,
                                  password: _passCont.text);
                        } else {
                          autovalid = AutovalidateMode.always;
                          setState(() {});
                        }
                      },
                      child: const Text('SignUp')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('have an account ? '),
                      GestureDetector(
                        onTap: () {
                          navigateLogin(context);
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  Flexible(flex: 2, child: Container()),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}

void navigateLogin(BuildContext context) {
  Navigator.of(context).pop();
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const Loginscreen()));
}

  // void regesterUser() async {
  //   await Authmethod().regesterUser(
  //       email: _emailCont.text,
  //       password: _passCont.text,
  //       name: _nameCont.text,
  //       bio: _bioCont.text);
  // }

  // void regesterUser() async {
  //   String resp = await Authmethod().registerUser(
  //       email: _emailCont.text,
  //       password: _passCont.text,
  //       username: _nameCont.text,
  //       bio: _bioCont.text);
  //   if (resp == 'success') {
  //     Navigator.pop(context);
  //     Navigator.of(context)
  //         .push(MaterialPageRoute(builder: (context) => Loginscreen()));
  //   }
  // }
// }

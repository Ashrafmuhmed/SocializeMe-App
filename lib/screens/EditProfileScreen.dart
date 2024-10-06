import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/services/userServices/UserServices.dart';
import '../widgets/CustomTextField.dart';
import 'loginScreen.dart';

class Editprofilescreen extends StatefulWidget {
  const Editprofilescreen({
    super.key,
    required this.currentUser,
  });
  final Userdata currentUser;
  @override
  State<Editprofilescreen> createState() => _EditprofilescreenState();
}

class _EditprofilescreenState extends State<Editprofilescreen> {
  final TextEditingController _bioCont = TextEditingController();
  final TextEditingController _nameCont = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;
  GlobalKey<FormState> formkey = GlobalKey();
  AutovalidateMode autovalid = AutovalidateMode.disabled;

  @override
  void dispose() {
    _bioCont.dispose();
    _nameCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Userdata virtualUser = widget.currentUser;
    return Scaffold(
      body: SafeArea(
          child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        blur: 14,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            autovalidateMode: autovalid,
            key: formkey,
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: const Border(top: BorderSide()),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: _image == null
                                    ? NetworkImage(widget.currentUser.imgLink)
                                    : MemoryImage(_image!),
                                fit: BoxFit.fitHeight)),
                      ),
                      Positioned(
                        top: 60,
                        left: 60,
                        child: IconButton(
                            onPressed: _selectImage,
                            icon: Icon(Icons.add_a_photo)),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  label: widget.currentUser.username,
                  inputType: TextInputType.name,
                  controller: _nameCont,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  label: widget.currentUser.bio,
                  inputType: TextInputType.text,
                  controller: _bioCont,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        setState(() {
                          _isLoading = true;
                        });
                        if (_image != null) {
                          await FirebaseStorage.instance
                              .ref(virtualUser.email)
                              .delete();
                        }
                        await FirebaseFirestore.instance
                            .collection('profiles')
                            .doc(virtualUser.uid)
                            .update({
                          'username': _nameCont.text == ''
                              ? virtualUser.username
                              : _nameCont.text,
                          'bio': _bioCont.text == ''
                              ? virtualUser.bio
                              : _bioCont.text,
                          'imgLink': _image != null
                              ? await uploadImageToStorage(
                                  childName: virtualUser.email, file: _image!)
                              : virtualUser.imgLink
                        });

                        //edit current user data on firebase
                      }
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Edit Profile')),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<void> _selectImage() async {
    Uint8List? img = await Userservices().pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }
}

void navigateLogin(BuildContext context) {
  Navigator.of(context).pop();
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const Loginscreen()));
}

Future<Uint8List> imageToUnit8List(String path) async {
  ByteData byteData = await rootBundle.load(path);
  return byteData.buffer.asUint8List();
}

Future<String> uploadImageToStorage(
    {required String childName, required Uint8List file}) async {
  FirebaseStorage _storage = FirebaseStorage.instance;
  Reference ref = _storage.ref().child(childName);
  UploadTask uploadTask = ref.putData(file);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

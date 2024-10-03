import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socializeme_app/Cubits/AddPostCubit/add_post_cubit.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/services/userServices/UserServices.dart';
import 'package:socializeme_app/widgets/CustomTextField.dart';

import '../Cubits/RegesterUserCubit/regester_user_cubit.dart';
import '../widgets/AddPostWidgets/AddPostForm.dart';

class Addpostscreen extends StatefulWidget {
  const Addpostscreen({super.key, required this.currentUser});
  final Userdata currentUser;

  @override
  State<Addpostscreen> createState() => _AddpostscreenState();
}

class _AddpostscreenState extends State<Addpostscreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();
  AutovalidateMode autovalid = AutovalidateMode.disabled;
  Uint8List? _image;
  Future<void> _selectImage() async {
    Uint8List? img = await Userservices().pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: const Text(
          'Add post',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: _selectImage, icon: const Icon(Icons.attach_file)),
          ElevatedButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  formkey.currentState!.save();
                  BlocProvider.of<AddPostCubit>(context).AddPost(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      file: _image);
                } else {
                  autovalid = AutovalidateMode.always;
                  setState(() {});
                }
              },
              child: Text('post')),
        ],
      ),
      body: AddPostForm(
          autovalid: autovalid,
          formkey: formkey,
          widget: widget,
          titleController: _titleController,
          descriptionController: _descriptionController,
          image: _image),
    );
  }
}

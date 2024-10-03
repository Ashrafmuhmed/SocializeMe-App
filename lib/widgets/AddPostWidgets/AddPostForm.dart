import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../screens/AddPostScreen.dart';
import '../CustomTextField.dart';

class AddPostForm extends StatelessWidget {
  const AddPostForm({
    super.key,
    required this.autovalid,
    required this.formkey,
    required this.widget,
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required Uint8List? image,
  })  : _titleController = titleController,
        _descriptionController = descriptionController,
        _image = image;

  final AutovalidateMode autovalid;
  final GlobalKey<FormState> formkey;
  final Addpostscreen widget;
  final TextEditingController _titleController;
  final TextEditingController _descriptionController;
  final Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: autovalid,
      key: formkey,
      child: ListView(
        children: [
          Card(
              margin: const EdgeInsets.only(top: 5),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      NetworkImage(widget.currentUser.imgLink),
                                  fit: BoxFit.fitHeight)),
                        ),
                        subtitle: Text(
                          DateTime.now().toString().substring(0, 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 139, 139, 139)),
                        ),
                        title: Text(
                          widget.currentUser.username,
                          style: const TextStyle(
                              color: Colors.amber, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        label: 'Title',
                        inputType: TextInputType.text,
                        controller: _titleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        maxLines: 5,
                        label: 'Description',
                        inputType: TextInputType.text,
                        controller: _descriptionController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _image != null
                          ? Container(
                              margin: const EdgeInsets.all(20),
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(44),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: MemoryImage(_image),
                                      fit: BoxFit.fitHeight)),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

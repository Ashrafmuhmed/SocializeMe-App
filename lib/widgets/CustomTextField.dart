import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.label,
      required this.inputType,
      this.secured = false,
      required this.controller,
      required this.validator});
  final TextInputType inputType;
  final String label;
  final bool secured;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:validator,
      controller: controller,
      obscureText: secured,
      keyboardType: inputType,
      cursorColor: Colors.indigoAccent,
      decoration: InputDecoration(
          label: Text(label),
          border:
              OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.purple),
              borderRadius: BorderRadius.all(Radius.circular(18))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          contentPadding: const EdgeInsets.all(10)),
    );
  }
}

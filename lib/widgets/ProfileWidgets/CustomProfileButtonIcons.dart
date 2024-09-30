import 'package:flutter/material.dart';

class CustomProfileButtonIcons extends StatelessWidget {
  const CustomProfileButtonIcons({super.key, required this.icondata,required this.onPressed});
  final IconData icondata;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15), topRight: Radius.circular(15)),
          gradient: LinearGradient(
              colors: [Colors.black, Color.fromARGB(255, 27, 27, 27)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: IconButton(
        icon: Icon(icondata),
        color: Colors.amber,
        onPressed: onPressed,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/screens/UserProfilePage.dart';

import '../widgets/ChatScreenWidgets/ChatStream.dart';
import '../widgets/ChatScreenWidgets/MessagingField.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key, required this.chatId, required this.User2});
  final String chatId;
  final Userdata User2;

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 44,
          title: GestureDetector(
            onTap: () {
              widget.User2.username != 'DeletedAccount' ?
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Userprofilepage(
                        user: widget.User2,
                      ))) : (){};
            },
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(widget.User2.imgLink),
                          fit: BoxFit.fitHeight)),
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: Text(
                    widget.User2.username,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            ChatStream(chatId: widget.chatId),
            widget.User2.username != 'DeletedAccount' ?
            MessagingField(
                textController: _textController,
                user2: widget.User2.uid,
                chatId: widget.chatId,
                firestore: _firestore) : Container(),
          ],
        ));
  }
}

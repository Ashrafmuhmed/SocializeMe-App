import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagingField extends StatelessWidget {
  const MessagingField(
      {super.key,
      required TextEditingController textController,
      required this.chatId,
      required FirebaseFirestore firestore,
      required this.user2})
      : _textController = textController,
        _firestore = firestore;

  final TextEditingController _textController;
  final String chatId;
  final FirebaseFirestore _firestore;
  final String user2;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 30, 30, 30),
        Color.fromARGB(255, 38, 38, 38)
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your message..',
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              if (_textController.text.isNotEmpty) {
                final text = _textController.text;
                _textController.clear();
                await FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatId)
                    .collection('messages')
                    .add({
                  'senderId': FirebaseAuth.instance.currentUser!.uid,
                  'message': text,
                  'timestamp': DateTime.now().toString(),
                  'isRead': false
                });
                await _firestore
                    .collection('profiles')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('UserChats')
                    .doc(chatId)
                    .update({
                  'lastMessage': text,
                  'time': DateTime.now().toString()
                });

                // Add to user2's UserChats subcollection
                await _firestore
                    .collection('profiles')
                    .doc(user2)
                    .collection('UserChats')
                    .doc(chatId)
                    .update({
                  'lastMessage': text,
                  'time': DateTime.now().toString()
                });
              }
            },
            icon: const Icon(
              Icons.send,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/messageModel.dart';

class MessageBubble extends StatelessWidget {
  final Messagemodel message;
  final bool isMe;  // Add this flag to control alignment
  final DateTime time;
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time
  });

  @override
  Widget build(BuildContext context) {
      log('Message sender: ${message.senderId}, Current user: ${FirebaseAuth.instance.currentUser?.uid}, isMe: $isMe');

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[400] : Colors.blue[400],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              time.toString().substring(0,16),  // Assuming timestamp is a Firestore Timestamp
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

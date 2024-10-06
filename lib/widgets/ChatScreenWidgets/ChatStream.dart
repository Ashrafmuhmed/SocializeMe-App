import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/messageModel.dart';
import '../ChatScreenWidgets/MessageBubble.dart';

class ChatStream extends StatelessWidget {
  const ChatStream({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Start a great conversation now !!'),
              );
            } else if (snapshot.hasData) {
              final messages = snapshot.data!.docs;
              // fmessages = snapshot.data.documents.reversed;
              List<Messagemodel> messageList = [];
              for (var message in messages) {
                print('Timestamp type: ${(message.data() as Map<String, dynamic>)['timestamp']} ${message.runtimeType}');
                messageList.add(Messagemodel.fromJson(
                    message.data() as Map<String, dynamic>));
              }

              bool isMe;
              return ListView.builder(
                  reverse: true,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    isMe = messageList[index].senderId ==
                        FirebaseAuth.instance.currentUser!.uid;
                    return MessageBubble(
                        message: messageList[index], isMe: isMe,time: messageList[index].time.toDate(),);
                  });
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(
              child: Text('Something went wrong, try again later'),
            );
          }),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socializeme_app/models/messageModel.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/widgets/SnackBarWidget.dart';
import 'package:intl/intl.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key, required this.chatId, required this.User2});
  final String chatId;
  final Userdata User2;

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 44,
          title: Row(
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
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(widget.chatId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        !snapshot.hasData) {
                      return const Center(
                        child: Text('Start a great conversation now !!'),
                      );
                    } else if (snapshot.hasData) {
                      final messages = snapshot.data!.docs;
                      List<Messagemodel> messageList = [];
                      for (var message in messages) {
                        messageList.add(Messagemodel.fromJson(
                            message.data() as Map<String, dynamic>));
                      }

                      return ListView.builder(
                          reverse: true,
                          itemCount: messageList.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(
                              message: messageList[index],
                            );
                          });
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const Center(
                      child: Text('Something went wrong, try again later'),
                    );
                  }),
            ),
            Container(
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
                            .doc(widget.chatId)
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
                            .doc(widget.chatId)
                            .update({
                          'lastMessage': text,
                          'time': DateTime.now().toString()
                        });

                        // Add to user2's UserChats subcollection
                        await _firestore
                            .collection('profiles')
                            .doc(widget.User2.uid)
                            .collection('UserChats')
                            .doc(widget.chatId)
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
            ),
          ],
        ));
  }
}

class MessageBubble extends StatelessWidget {
  final Messagemodel message; // New parameter

  const MessageBubble({
    super.key,
    required this.message, // Initialize new parameter
  });
  @override
  Widget build(BuildContext context) {
    final bool isCurrentUser =
        FirebaseAuth.instance.currentUser!.uid == message.senderId;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              borderRadius: isCurrentUser
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
              color: isCurrentUser
                  ? (message.isRead
                      ? const Color.fromARGB(255, 131, 131, 131)
                      : const Color.fromARGB(255, 63, 88, 42))
                  : (message.isRead
                      ? Colors.pink.shade200
                      : const Color.fromARGB(255, 27, 81, 83)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    message.time,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

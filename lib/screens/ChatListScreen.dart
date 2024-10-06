import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/screens/chatscreen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('profiles')
            .doc(_auth.currentUser!.uid)
            .collection('UserChats')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No chats available'),
            );
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatData = chats[index].data() as Map<String, dynamic>;
              final chatId = chatData['ChatId'];
              final otherUserId = chatData['user1Uid'] == _auth.currentUser!.uid
                  ? chatData['user2Uid']
                  : chatData['user1Uid'];

              // Fetch the other user's data
              return FutureBuilder<DocumentSnapshot>(
                future:
                    _firestore.collection('profiles').doc(otherUserId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    );
                  }

                  Userdata otherUser = Userdata.json(
                    userData: userSnapshot.data!.data() as Map<String, dynamic>,
                  );

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(otherUser.imgLink),
                      ),
                      title: Text(
                        otherUser.username,
                        style: TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text(chatData['lastMessage'] ?? 'Tap to start chat'),
                      onTap: () {
                        // Navigate to chat screen with chatId and other user data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatscreen(
                              chatId: chatId,
                              User2: otherUser,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

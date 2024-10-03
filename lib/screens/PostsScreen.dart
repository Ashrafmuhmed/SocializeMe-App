import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socializeme_app/models/PostModel.dart';
import 'package:socializeme_app/widgets/SnackBarWidget.dart';

import '../models/userData.dart';

class Postsscreen extends StatefulWidget {
  const Postsscreen({super.key});

  @override
  State<Postsscreen> createState() => _PostsscreenState();
}

class _PostsscreenState extends State<Postsscreen> {
  final Stream _usersStream =
      FirebaseFirestore.instance.collection('UserPosts').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _usersStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));
            }
            List<dynamic> data = snapshot.data.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var post = data[index];
                return FutureBuilder(
                  future: getUserData(post['userUid']),
                  builder:
                      (BuildContext context, AsyncSnapshot<Userdata> userSnap) {
                    if (userSnap.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.amber,
                      ));
                    }
                    if (userSnap.hasError) {
                      return const Text('Error fetching user data');
                    }
                    Userdata user = userSnap.data!;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Container(
                                width: 50,
                                height: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(user.imgLink),
                                        fit: BoxFit.fitHeight)),
                              ),
                              title: Text(user.username),
                              subtitle: Text(
                                  post['time']), // Assuming Userdata has 'name'
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    post['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Text(
                                    post['description'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white38),
                                  ),
                                ),
                              ],
                            ),
                            post['imgLink'] != null
                                ? Image.network(post['imgLink'])
                                : Container(),
                            SizedBox(
                              height: 14,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }),
    );
  }

  Future<Userdata> getUserData(String uid) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('profiles').doc(uid).get();
    return Userdata.json(userData: snapshot.data() as Map<String, dynamic>);
  }
}
//currentUser = Userdata.json(
                    // userData: snapshot.data!.data() as Map<String, dynamic>);
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socializeme_app/models/PostModel.dart';
import 'package:socializeme_app/models/userData.dart';

import '../../screens/CurrentUserProfileScreen.dart';
import '../../screens/UserProfilePage.dart';
class PostCard extends StatelessWidget {
  PostCard({
    super.key,
    required this.post,
    this.user
  });

  final Postmodel post;
  final Userdata? user;
  @override
  Widget build(BuildContext context) {
    if(user != null)
    post.user = user;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                if(post.user!.uid == FirebaseAuth.instance.currentUser!.uid) 
                {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Profilescreen()));
                }
                else
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Userprofilepage(user: post.user!)));
              },
              leading: Container(
                width: 50,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(post.user!.imgLink),
                        fit: BoxFit.fitHeight)),
              ),
              title: Text(post.user!.username),
              subtitle: Text(post.time), // Assuming Userdata has 'name'
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
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
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    post.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white38),
                  ),
                ),
              ],
            ),
            post.imgLink != null ? Image.network(post.imgLink!) : Container(),
            SizedBox(
              height: 14,
            )
          ],
        ),
      ),
    );
  }
}
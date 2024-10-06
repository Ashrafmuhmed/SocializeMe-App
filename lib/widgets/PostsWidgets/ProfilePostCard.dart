import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socializeme_app/models/PostModel.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/widgets/SnackBarWidget.dart';

class Profilepostcard extends StatelessWidget {
  Profilepostcard({
    super.key,
    required this.post,
    this.user,
    required this.current
  });

  final Postmodel post;
  final Userdata? user;
  final bool current;
  @override
  Widget build(BuildContext context) {
    if (user != null) {
      post.user = user;
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {},
                trailing: current ? IconButton(
                onPressed: () async {
                  if (post.imgLink != null) {
                    await FirebaseStorage.instance.ref(post.postId).delete();
                  }
                  FirebaseFirestore.instance
                      .collection('profiles')
                      .doc(post.user!.uid)
                      .update({
                    'postsIds': FieldValue.arrayRemove([post.postId]),
                  });
                  await FirebaseFirestore.instance
                      .collection('UserPosts')
                      .doc(post.postId)
                      .delete();
                  Snackbarwidget().ShowSnackbar(
                      context: context, message: 'Posts deleted successfully');
                },
                icon: Icon(Icons.delete_forever),
                color: Colors.red,
              ) : Icon(Icons.schema_outlined),
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

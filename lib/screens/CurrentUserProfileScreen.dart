import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/screens/loginScreen.dart';
import 'package:socializeme_app/widgets/PostsWidgets/ProfilePostCard.dart';
import '../Cubits/CurrentUserPostsCubit/current_user_posts_cubit.dart';
import '../constants/constants.dart';
import '../models/PostModel.dart';
import '../widgets/ProfileWidgets/UserProfilePageHead.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});
    static final String id = 'CurrentProifle';

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  List<Postmodel> posts = [];
  final User? _cred = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? currentUserData;
  Userdata? currentUser;
  bool postLoading = true;
  bool noPosts = false;
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<CurrentUserPostsCubit>(context).getPosts(uid: _cred!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentUserPostsCubit, CurrentUserPostsState>(
      listener: (context, state) {
        if (state is CurrentUserPostsFailure) {
          log('State is CurrentUserPostsFailure');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Something went wrong, try again later')));
        } else if (state is CurrentUserPostsSuccess) {
          log('CurrentUserPostsSuccess - Posts length: ${state.posts.length}');
          state.posts.isNotEmpty
              ? setState(() {
                  postLoading = false;
                  posts = state.posts;
                  posts.sort((a, b) => b.time.compareTo(a.time));
                })
              : setState(() {
                  noPosts = true;
                });
        } else if (state is CurrentUserPostsLoading) {
          log('State: CurrentUserPostsLoading');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Profile'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool(login_check, false);
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Loginscreen()));
                },
                icon: const Icon(Icons.output_rounded))
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: firestore.collection('profiles').doc(_cred!.uid).get(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done ||
                  snapshot.hasData) {
                currentUser = Userdata.json(
                    userData: snapshot.data!.data() as Map<String, dynamic>);
                return CustomScrollView(slivers: [
                  SliverToBoxAdapter(
                      child: UserProfilePageHead(currentUser: currentUser!)),
                  const SliverToBoxAdapter(
                      child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 133, 133, 133),
                            thickness: 2,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          "Posts",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color.fromARGB(255, 133, 133, 133),
                            thickness: 2,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),
                  )),
                  noPosts
                      ? const SliverToBoxAdapter(
                          child: Center(
                          child: Text('No posts yet',
                              style: TextStyle(fontSize: 20)),
                        ))
                      : !postLoading
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return Profilepostcard(
                                    post: posts[index],
                                    user: currentUser,
                                  ); // Your PostCard widget
                                },
                                childCount: posts.length,
                              ),
                            )
                          : const SliverToBoxAdapter(
                              child: Center(
                                  child: CircularProgressIndicator(
                              color: Colors.amber,
                            ))),
                ]);
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.amber,
                ));
              }
            }),
      ),
    );
  }
}

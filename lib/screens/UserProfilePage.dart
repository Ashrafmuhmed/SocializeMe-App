import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socializeme_app/models/PostModel.dart';
import 'package:socializeme_app/models/userData.dart';
import 'package:socializeme_app/widgets/PostsWidgets/ProfilePostCard.dart';
import 'package:socializeme_app/widgets/ProfileWidgets/OtherUserProfilePageHead.dart';

import '../Cubits/CurrentUserPostsCubit/current_user_posts_cubit.dart';

class Userprofilepage extends StatefulWidget {
  Userprofilepage({super.key, required this.user});
  final Userdata user;
  @override
  State<Userprofilepage> createState() => _UserprofilepageState();
}

class _UserprofilepageState extends State<Userprofilepage> {
  void initState() {
    // TODO: implement initState
    BlocProvider.of<CurrentUserPostsCubit>(context)
        .getPosts(uid: widget.user.uid);
    super.initState();
  }

  bool postLoading = true;
  bool noPosts = false;
  List<Postmodel> posts = [];
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
          if (state.posts.isNotEmpty) {
            postLoading = false;
            noPosts = false;
            posts = state.posts;
            posts.sort((a, b) => b.time.compareTo(a.time));
            setState(() {});
          } else {
            noPosts = true;
            setState(() {});
          }
        } else if (state is CurrentUserPostsLoading) {
          log('State: CurrentUserPostsLoading');
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverToBoxAdapter(
                child: Otheruserprofilepagehead(currentUser: widget.user)),
            const SliverToBoxAdapter(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
                    child: Text('No posts yet', style: TextStyle(fontSize: 20)),
                  ))
                : !postLoading
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Profilepostcard(
                              post: posts[index],
                              user: widget.user,
                              current: false,
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
          ],
        ),
      ),
    );
  }
}

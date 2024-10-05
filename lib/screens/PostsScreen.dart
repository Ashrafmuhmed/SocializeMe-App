import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socializeme_app/Cubits/FetchAllPostsCubit/fetch_all_posts_cubit.dart';
import 'package:socializeme_app/models/PostModel.dart';
import 'package:socializeme_app/widgets/PostsWidgets/PostCard.dart';

//currentUser = Userdata.json(
// userData: snapshot.data!.data() as Map<String, dynamic>);

class Postsscreen extends StatefulWidget {
  const Postsscreen({super.key});

  @override
  State<Postsscreen> createState() => _PostsscreenState();
}

class _PostsscreenState extends State<Postsscreen> {
  List<Postmodel> posts = [];

  @override
  void initState() {
    super.initState();
    // Fetch the posts when the screen is initialized
    BlocProvider.of<FetchAllPostsCubit>(context).fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FetchAllPostsCubit, FetchAllPostsState>(
      listener: (context, state) {
        if (state is FetchAllPostsFailure) {
          log('State is FetchAllPostsFailure');
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Something went wrong, try again later')));
        } else if (state is FetchAllPostsSuccess) {
          log('State: FetchAllPostsSuccess - Posts length: ${state.posts.length}');
          setState(() {
            posts = state.posts;
          });
        } else if (state is FetchAllPostsLoading) {
          log('State: FetchAllPostsLoading');
        }
      },
      child: Scaffold(
        body: BlocBuilder<FetchAllPostsCubit, FetchAllPostsState>(
          builder: (context, state) {
            if (state is FetchAllPostsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              );
            }
            return posts.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<FetchAllPostsCubit>(context)
                          .fetchAllPosts();
                    },
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: PostCard(post: posts[index]),
                        );
                      },
                    ),
                  )
                : const Center(child: Text('No posts to display'));
          },
        ),
      ),
    );
  }
}

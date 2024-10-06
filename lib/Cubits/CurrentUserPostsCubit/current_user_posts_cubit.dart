import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:socializeme_app/models/PostModel.dart';

part 'current_user_posts_state.dart';

class CurrentUserPostsCubit extends Cubit<CurrentUserPostsState> {
  CurrentUserPostsCubit( ) : super(CurrentUserPostsInitial());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void getPosts({required String uid}) async {
    List<Postmodel> posts = [];
    emit(CurrentUserPostsLoading());

    try {
      var postsSnap = await _firestore
          .collection('profiles')
          .doc(uid)
          .get();
      List<dynamic> postsData = postsSnap.data()!['postsIds'];
      for (var element in postsData) {
        var postData =
            await _firestore.collection('UserPosts').doc(element).get();

        var postFetched = postData.data();

        Postmodel post = Postmodel(
          title: postFetched!['title'],
          description: postFetched['description'],
          time: postFetched['time'],
          imgLink: postFetched['imgLink'],
          userUid: postFetched['userUid'],
          postId: postFetched['postId'],
        );

        log('Post fetched: ${post}');
        posts.add(post);
      }

      emit(CurrentUserPostsSuccess(posts: posts));
    } catch (e) {
      emit(CurrentUserPostsFailure(message: e.toString()));
    }
  }
}

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../models/PostModel.dart';
import '../../models/userData.dart';

part 'fetch_all_posts_state.dart';

class FetchAllPostsCubit extends Cubit<FetchAllPostsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FetchAllPostsCubit() : super(FetchAllPostsInitial());

  Future<void> fetchAllPosts() async {
    List<Postmodel> posts = [];
    emit(FetchAllPostsLoading());

    try {
      var postsSnap = await _firestore
          .collection('UserPosts')
          .orderBy('time', descending: true)
          .get();

      for (var element in postsSnap.docs) {
      log('Post fetched: ${element.data()}');
      var postData = element.data();
      var userUid = postData['userUid'];

        var userData = await getUserData(uid: userUid);
        log('User data fetched for $userUid: $userData');
 
        Postmodel post = Postmodel(
          title: postData['title'],
          description: postData['description'],
          time: postData['time'],
          user: userData, userUid: postData['userUid'],
          imgLink: postData['imgLink'],
          postId: postData['postId'],
        );

        posts.add(post);
      }

      emit(FetchAllPostsSuccess(posts: posts));
    } catch (e) {
      emit(FetchAllPostsFailure(error: e as Exception));
    }
  }

  Future<Userdata> getUserData({required String uid}) async {
    var snapshot = await _firestore.collection('profiles').doc(uid).get();
    return Userdata.json(userData: snapshot.data() as Map<String, dynamic>);
  }
}

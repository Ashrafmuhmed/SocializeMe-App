import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'chats_procider_state.dart';

class ChatsProciderCubit extends Cubit<ChatsProciderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String user1Uid = FirebaseAuth.instance.currentUser!.uid;
  ChatsProciderCubit() : super(ChatsProciderInitial());

  SearchChats(String user2Uid) async {

    emit(ChatsProciderSearching());

    try{
      var user1ChatsCollection = _firestore
          .collection('profiles')
          .doc(user1Uid)
          .collection('UserChats');
      var querySnapshot = await user1ChatsCollection
          .where('user2Uid', isEqualTo: user2Uid)
          .where('user1Uid', isEqualTo: user1Uid)
          .get();    
          if (querySnapshot.docs.isNotEmpty) {
        var chatDoc = querySnapshot.docs.first;
        var chatId = chatDoc['ChatId'];
        emit(ChatsProciderFound(ChatId: chatId));
      } else {
        querySnapshot = await user1ChatsCollection
          .where('user2Uid', isEqualTo: user1Uid)
          .where('user1Uid', isEqualTo: user2Uid)
          .get();  
          if (querySnapshot.docs.isNotEmpty) {
        var chatDoc = querySnapshot.docs.first;
        var chatId = chatDoc['ChatId'];
        emit(ChatsProciderFound(ChatId: chatId));
      } else{

        emit(ChatsProciderNotFound());
        createNewChat(user2Uid);
      }
      }
    }
    catch(e){
      emit(ChatsProciderError(e.toString()));
    }
  }

  Future<void> createNewChat(String user2Uid) async {
    emit(ChatsProciderCreating());

    try {
      // Generate a new unique ChatId
      var chatId = _firestore.collection('chats').doc().id;

      // Add to user1's UserChats subcollection
      await _firestore
          .collection('profiles')
          .doc(user1Uid)
          .collection('UserChats')
          .doc(chatId)
          .set({
        'user1Uid': user1Uid,
        'user2Uid': user2Uid,
        'ChatId': chatId,
      });

      // Add to user2's UserChats subcollection
      await _firestore
          .collection('profiles')
          .doc(user2Uid)
          .collection('UserChats')
          .doc(chatId)
          .set({
        'user1Uid': user1Uid,
        'user2Uid': user2Uid,
        'ChatId': chatId,
      });

      // Create the chat document in the Chats collection
      await _firestore.collection('chats').doc(chatId).set({
        'user1Uid': user1Uid,
        'user2Uid': user2Uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Emit the success state with the new ChatId
      emit(ChatsProciderFound(ChatId: chatId));
    } catch (e) {
      // Handle errors
      emit(ChatsProciderError(e.toString()));
    }
  }
}

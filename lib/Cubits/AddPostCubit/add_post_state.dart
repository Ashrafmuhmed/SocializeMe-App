part of 'add_post_cubit.dart';

@immutable
sealed class AddPostState {}

final class AddPostInitial extends AddPostState {}
final class AddPostLoading extends AddPostState {}
final class AddPostFailed extends AddPostState {
  final FirebaseException exception;
  AddPostFailed({required this.exception});
}
final class AddPostSuccess extends AddPostState {}

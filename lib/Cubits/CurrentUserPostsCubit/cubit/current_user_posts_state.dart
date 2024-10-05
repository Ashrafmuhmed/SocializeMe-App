part of 'current_user_posts_cubit.dart';

@immutable
sealed class CurrentUserPostsState {}

final class CurrentUserPostsInitial extends CurrentUserPostsState {}
final class CurrentUserPostsSuccess extends CurrentUserPostsState {
  final List<Postmodel> posts;
  CurrentUserPostsSuccess({required this.posts});
}
final class CurrentUserPostsLoading extends CurrentUserPostsState {}
final class CurrentUserPostsFailure extends CurrentUserPostsState {
  final String message;
  CurrentUserPostsFailure({required this.message});
}

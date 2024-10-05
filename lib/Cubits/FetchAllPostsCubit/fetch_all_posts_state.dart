part of 'fetch_all_posts_cubit.dart';

@immutable
sealed class FetchAllPostsState {}

final class FetchAllPostsInitial extends FetchAllPostsState {}
final class FetchAllPostsLoading extends FetchAllPostsState {}
final class FetchAllPostsSuccess extends FetchAllPostsState {
  final List<Postmodel> posts;
  FetchAllPostsSuccess({required this.posts});
}
// ignore: must_be_immutable
final class FetchAllPostsFailure extends FetchAllPostsState {
  final Exception error;
  FetchAllPostsFailure({required this.error});
}

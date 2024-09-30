part of 'regester_user_cubit.dart';

@immutable
sealed class RegesterUserState {}

final class RegesterUserInitial extends RegesterUserState {}

final class RegesterUserLoading extends RegesterUserState {}

final class RegesterUserSuccess extends RegesterUserState {}

final class RegesterUserFailure extends RegesterUserState {
  final FirebaseAuthException exception;
  RegesterUserFailure({required this.exception});
}

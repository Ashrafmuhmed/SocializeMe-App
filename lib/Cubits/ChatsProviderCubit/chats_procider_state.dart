part of 'chats_procider_cubit.dart';

@immutable
sealed class ChatsProciderState {}

final class ChatsProciderInitial extends ChatsProciderState {}

final class ChatsProciderSearching extends ChatsProciderState {}

final class ChatsProciderCreating extends ChatsProciderState {}

final class ChatsProciderFound extends ChatsProciderState {
  String ChatId;

  ChatsProciderFound({required this.ChatId});
}

final class ChatsProciderNotFound extends ChatsProciderState {}

final class ChatsProciderError extends ChatsProciderState {
  ChatsProciderError(String string);
}

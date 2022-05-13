part of 'start_up_bloc.dart';

@freezed
class StartUpState with _$StartUpState {
  const factory StartUpState.content() = ContentStartUpState;

  // Sync State: open Register Page.
  const factory StartUpState.openSignIn() = OpenSignInStartUpState;

  // Sync State: open All Chats Page.
  const factory StartUpState.openAllChats() = OpenAllChatsStartUpPage;
}

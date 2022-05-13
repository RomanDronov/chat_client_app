part of 'sign_in_bloc.dart';

@freezed
class SignInState with _$SignInState {
  const factory SignInState.content({
    required bool isLoading,
  }) = ContentSignInState;

  const factory SignInState.openSignUp() = OpenSignUpSignInState;
  const factory SignInState.openAllChats() = OpenAllChatsSignInState;
  const factory SignInState.showEmailFailure({
    required String failure,
  }) = ShowEmailFailureSignInState;
  const factory SignInState.showPasswordFailure({
    required String failure,
  }) = ShowPasswordFailureSignInState;
}

part of 'sign_in_bloc.dart';

@freezed
class SignInEvent with _$SignInEvent {
  const factory SignInEvent.signInPressed({
    required String email,
    required String password,
  }) = SignInPressedSignInEvent;
  const factory SignInEvent.signUpPressed() = SignUpPressedSignInEvent;
}

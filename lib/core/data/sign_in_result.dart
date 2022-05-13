import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_result.freezed.dart';

@freezed
class SignInResult with _$SignInResult {
  const factory SignInResult.success() = SuccessSignInResult;
  const factory SignInResult.invalidEmail() = InvalidEmailSignInResult;
  const factory SignInResult.wrongPassword() = WrongPasswordSignInResult;
  const factory SignInResult.userNotFound() = UserNotFoundSignInResult;
  const factory SignInResult.unknownFailure() = UnknownFailureSignInResult;
}

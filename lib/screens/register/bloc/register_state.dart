part of 'register_bloc.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.content({required bool isLoading}) = ContentRegisterState;
  const factory RegisterState.openAllChats() = OpenAllChatsRegisterState;
}

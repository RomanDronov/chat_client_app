part of 'register_bloc.dart';

@freezed
class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.started() = StartedRegisterEvent;
  const factory RegisterEvent.submitPressed({
    required String name,
    required String email,
    required String password,
  }) = SubmitPressedRegisterEvent;
}
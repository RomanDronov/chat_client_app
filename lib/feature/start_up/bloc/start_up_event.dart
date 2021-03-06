part of 'start_up_bloc.dart';

@freezed
class StartUpEvent with _$StartUpEvent {
  const factory StartUpEvent.started() = StartedStartUpEvent;
  const factory StartUpEvent.submitPressed({
    required String email,
    required String password,
  }) = SubmitPressedStartUpEvent;
}

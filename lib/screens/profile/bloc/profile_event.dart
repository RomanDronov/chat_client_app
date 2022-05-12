part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.initialized() = InitializedProfileEvent;
  const factory ProfileEvent.logOutPressed() = LogOutPressedProfileEvent;
  const factory ProfileEvent.genderChanged({required Gender gender}) = GenderChangedProfileEvent;
}

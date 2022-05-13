part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial({required ChatUser user}) = InitialProfileState;
  const factory ProfileState.loading() = LoadingProfileState;

  const factory ProfileState.logout() = LogoutProfileState;
}

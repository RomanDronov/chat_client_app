import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/data/user_repository.dart';
import '../../../models/chat_user.dart';
import '../../../models/gender.dart';
import '../../../utils/emitter_extensions.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  ProfileBloc(this._userRepository) : super(const ProfileState.loading()) {
    on<InitializedProfileEvent>(_onInitialized);
    on<LogOutPressedProfileEvent>(_onLogOutPressed);
    on<GenderChangedProfileEvent>(_onGenderChanged);
    on<DistanceUpdatePressedProfileEvent>(_onDistanceUpdatePressed, transformer: restartable());
  }

  FutureOr<void> _onInitialized(InitializedProfileEvent event, Emitter<ProfileState> emit) async {
    final ChatUser currentUser = await _userRepository.getCurrentUser(isForce: true);
    emit(ProfileState.initial(user: currentUser));
  }

  FutureOr<void> _onLogOutPressed(
    LogOutPressedProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _userRepository.logout();
    emit.sync(state, const ProfileState.logout());
  }

  FutureOr<void> _onGenderChanged(
    GenderChangedProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _userRepository.updateGender(gender: event.gender);
    final ChatUser currentUser = await _userRepository.getCurrentUser();
    emit(ProfileState.initial(user: currentUser));
  }

  FutureOr<void> _onDistanceUpdatePressed(
    DistanceUpdatePressedProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final ProfileState oldState = state;
    if (oldState is InitialProfileState) {
      emit(oldState.copyWith(user: oldState.user.copyWith(distance: event.distance)));
    }
    await Future.delayed(const Duration(milliseconds: 500));
    await _userRepository.updateDistance(distance: event.distance);
  }
}

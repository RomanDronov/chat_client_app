import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
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
}

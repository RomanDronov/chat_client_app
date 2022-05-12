import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/user_repository.dart';
import '../../../models/chat_user.dart';
import '../../../utils/emitter_extensions.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  ProfileBloc(this._userRepository) : super(const ProfileState.loading()) {
    on<InitializedProfileEvent>(_onInitialized);
    on<LogOutPressedProfileEvent>(_onLogOutPressed);
  }

  FutureOr<void> _onInitialized(InitializedProfileEvent event, Emitter<ProfileState> emit) async {
    final ChatUser currentUser = await _userRepository.getCurrentUser(isForce: true);

    emit(ProfileState.initial(user: currentUser));
  }

  FutureOr<void> _onLogOutPressed(LogOutPressedProfileEvent event, Emitter<ProfileState> emit) {
    emit.sync(state, const ProfileState.logout());
  }
}

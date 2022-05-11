import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/chat_user.dart';
import '../../../utils/chat_user_converter.dart';
import '../../../utils/emitter_extensions.dart';

part 'start_up_bloc.freezed.dart';
part 'start_up_event.dart';
part 'start_up_state.dart';

class StartUpBloc extends Bloc<StartUpEvent, StartUpState> {
  StartUpBloc() : super(const StartUpState.content()) {
    on<StartedStartUpEvent>(_onStarted);
  }

  FutureOr<void> _onStarted(StartedStartUpEvent event, Emitter<StartUpState> emit) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      emit.sync(const StartUpState.content(), const StartUpState.openAllChats());
    } else {
      emit.sync(const StartUpState.content(), const StartUpState.openRegister());
    }
  }
}

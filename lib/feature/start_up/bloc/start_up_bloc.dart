import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/emitter_extensions.dart';

part 'start_up_bloc.freezed.dart';
part 'start_up_event.dart';
part 'start_up_state.dart';

class StartUpBloc extends Bloc<StartUpEvent, StartUpState> {
  StartUpBloc() : super(const StartUpState.content()) {
    on<StartedStartUpEvent>(_onStarted);
  }

  FutureOr<void> _onStarted(StartedStartUpEvent event, Emitter<StartUpState> emit) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    await Future.delayed(const Duration(seconds: 1));

    if (currentUser != null) {
      emit.sync(const StartUpState.content(), const StartUpState.openAllChats());
    } else {
      emit.sync(const StartUpState.content(), const StartUpState.openSignIn());
    }
  }
}

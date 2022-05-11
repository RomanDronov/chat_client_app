import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/user_repository.dart';
import '../../../models/chat_user.dart';
import '../../../utils/emitter_extensions.dart';
import '../../startup/bloc/start_up_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  RegisterBloc(this._userRepository) : super(RegisterState.content(isLoading: false)) {
    on<SubmitPressedRegisterEvent>(_onSubmitPressed);
  }

  FutureOr<void> _onSubmitPressed(
    SubmitPressedRegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterState.content(isLoading: true));
    final ChatUser user = await _userRepository.registerUser(
      event.email,
      event.password,
      event.name,
    );
    emit.sync(RegisterState.content(isLoading: false), RegisterState.openAllChats());
  }
}

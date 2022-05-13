import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/data/user_repository.dart';
import '../../../utils/emitter_extensions.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  RegisterBloc(this._userRepository) : super(const RegisterState.content(isLoading: false)) {
    on<SubmitPressedRegisterEvent>(_onSubmitPressed);
  }

  FutureOr<void> _onSubmitPressed(
    SubmitPressedRegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterState.content(isLoading: true));
    await _userRepository.registerUser(
      event.email,
      event.password,
      event.name,
    );
    emit.sync(
      const RegisterState.content(isLoading: false),
      const RegisterState.openAllChats(),
    );
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/data/user_repository.dart';
import '../../../utils/emitter_extensions.dart';

part 'register_bloc.freezed.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  final String _email;
  final String _password;
  RegisterBloc(
    this._userRepository,
    this._email,
    this._password,
  ) : super(const RegisterState.content(isLoading: false)) {
    on<SubmitPressedRegisterEvent>(_onSubmitPressed);
  }

  FutureOr<void> _onSubmitPressed(
    SubmitPressedRegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterState.content(isLoading: true));

    final String username = event.username.trim();
    final String? usernameFailure = _getUsernameFailureOrNull(username);

    if (usernameFailure != null) {
      emit.sync(
        const RegisterState.content(isLoading: false),
        RegisterState.showUsernameFailure(failure: usernameFailure),
      );
      return;
    }

    await _userRepository.registerUser(
      _email,
      _password,
      username,
    );
    emit.sync(
      const RegisterState.content(isLoading: false),
      const RegisterState.openAllChats(),
    );
  }

  String? _getUsernameFailureOrNull(String username) {
    if (username.isEmpty) {
      return 'Fill in Username please';
    }
    if (username.length < 8) {
      return 'Must be at least 8 characters';
    }
    return null;
  }
}

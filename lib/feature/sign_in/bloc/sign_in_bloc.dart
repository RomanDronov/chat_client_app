import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/data/sign_in_result.dart';
import '../../../core/data/user_repository.dart';
import '../../../utils/emitter_extensions.dart';

part 'sign_in_bloc.freezed.dart';
part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;
  SignInBloc(this._userRepository) : super(const SignInState.content(isLoading: false)) {
    on<SignInPressedSignInEvent>(_onSignInPressed);
    on<SignUpPressedSignInEvent>(_onSignUpPressed);
  }

  FutureOr<void> _onSignInPressed(SignInPressedSignInEvent event, Emitter<SignInState> emit) async {
    bool hasFailures = false;
    final String email = event.email.trim();
    final String? emailFailure = _getEmailFailureOrNull(email);
    if (emailFailure != null) {
      emit.sync(state, SignInState.showEmailFailure(failure: emailFailure));
      hasFailures = true;
    }

    final String password = event.password.trim();
    final String? passwordFailure = _getPasswordFailureOrNull(password);
    if (passwordFailure != null) {
      emit.sync(state, SignInState.showPasswordFailure(failure: passwordFailure));
      hasFailures = true;
    }

    if (hasFailures) {
      return;
    }
    emit(const SignInState.content(isLoading: true));
    final SignInResult result = await _userRepository.signIn(email, password);
    emit(const SignInState.content(isLoading: false));
    result.when(
      success: () {
        emit.sync(state, const SignInState.openAllChats());
      },
      invalidEmail: () {
        emit.sync(state, const SignInState.showEmailFailure(failure: 'This email is invalid'));
      },
      wrongPassword: () {
        emit.sync(state, const SignInState.showPasswordFailure(failure: 'This password is wrong'));
      },
      userNotFound: () {},
      unknownFailure: () {},
    );
  }

  FutureOr<void> _onSignUpPressed(SignUpPressedSignInEvent event, Emitter<SignInState> emit) {
    emit.sync(state, const SignInState.openSignUp());
  }

  String? _getEmailFailureOrNull(String email) {
    if (email.isEmpty) {
      return 'Fill in Email please';
    }
    return null;
  }

  String? _getPasswordFailureOrNull(String password) {
    if (password.isEmpty) {
      return 'Fill in Password please';
    }
    if (password.length < 8) {
      return 'This password is too short';
    }
    return null;
  }
}

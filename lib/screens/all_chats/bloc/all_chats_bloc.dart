import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/user_repository.dart';
import '../../../models/chat_user.dart';
import '../../../utils/chat_user_converter.dart';
import '../../../utils/emitter_extensions.dart';

part 'all_chats_event.dart';
part 'all_chats_state.dart';
part 'all_chats_bloc.freezed.dart';

class AllChatsBloc extends Bloc<AllChatsEvent, AllChatsState> {
  final UserRepository _userRepository;
  AllChatsBloc(this._userRepository) : super(AllChatsState.loading()) {
    on<InitializedAllChatsEvent>(_onInitialized);
    on<UserPressedAllChatsEvent>(_onUserPressed);
    on<LogoutPressedAllChatsEvent>(_onLogoutPressed);
  }

  FutureOr<void> _onUserPressed(
    UserPressedAllChatsEvent event,
    Emitter<AllChatsState> emit,
  ) {
    emit.sync(state, AllChatsState.openChat(user: event.user));
  }

  FutureOr<void> _onInitialized(
    InitializedAllChatsEvent event,
    Emitter<AllChatsState> emit,
  ) async {
    final List<ChatUser> users = await _userRepository.getAllUsers(isForce: true);
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    final List<ChatUser> friends =
        users.where((user) => user.chatID != currentUser?.chatID).toList();
    emit(AllChatsState.content(users: friends));
  }

  FutureOr<void> _onLogoutPressed(
    LogoutPressedAllChatsEvent event,
    Emitter<AllChatsState> emit,
  ) async {
    await _userRepository.logout();
    emit.sync(state, AllChatsState.logout());
  }
}

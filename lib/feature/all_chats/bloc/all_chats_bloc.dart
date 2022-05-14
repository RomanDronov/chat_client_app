import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/data/user_repository.dart';
import '../../../models/chat_user.dart';
import '../../../utils/emitter_extensions.dart';

part 'all_chats_bloc.freezed.dart';
part 'all_chats_event.dart';
part 'all_chats_state.dart';

class AllChatsBloc extends Bloc<AllChatsEvent, AllChatsState> {
  final UserRepository _userRepository;
  AllChatsBloc(this._userRepository) : super(const AllChatsState.loading()) {
    on<InitializedAllChatsEvent>(_onInitialized);
    on<UserPressedAllChatsEvent>(_onUserPressed);
    on<ProfilePressedAllChatEvent>(_onProfilePressed);
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
    final List<ChatUser> friends = users.where((user) => user.id != currentUser?.id).toList();
    emit(AllChatsState.content(users: friends));
    await Future.delayed(const Duration(seconds: 5));
    add(event);
  }

  FutureOr<void> _onProfilePressed(ProfilePressedAllChatEvent event, Emitter<AllChatsState> emit) {
    emit.sync(state, const AllChatsState.openProfile());
  }
}

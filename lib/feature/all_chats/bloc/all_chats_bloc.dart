import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/data/user_repository.dart';
import '../../../core/util/stream_socket.dart';
import '../../../models/chat_user.dart';
import '../../../utils/emitter_extensions.dart';
import '../domain/all_chats_service.dart';
import '../models/domain/all_chats_details.dart';
import '../models/domain/get_all_chats_details_result.dart';

part 'all_chats_bloc.freezed.dart';
part 'all_chats_event.dart';
part 'all_chats_state.dart';

class AllChatsBloc extends Bloc<AllChatsEvent, AllChatsState> {
  final AllChatsService _service;
  final UserRepository _userRepository;
  AllChatsBloc(this._service, this._userRepository) : super(const AllChatsState.loading()) {
    on<InitializedAllChatsEvent>(_onInitialized);
    on<RecipientPressedAllChatsEvent>(_onUserPressed);
    on<ProfilePressedAllChatEvent>(_onProfilePressed);
  }

  FutureOr<void> _onUserPressed(
    RecipientPressedAllChatsEvent event,
    Emitter<AllChatsState> emit,
  ) {
    emit.sync(state, AllChatsState.openChat(recipient: event.recipient, chatId: event.chatId));
  }

  FutureOr<void> _onInitialized(
    InitializedAllChatsEvent event,
    Emitter<AllChatsState> emit,
  ) async {
    emit(const AllChatsState.loading());
    final ChatUser user = await _userRepository.getCurrentUser(isForce: false);
    final PayloadStream<GetAllChatsDetailsResult> payloadStream =
        await _service.subscribeToDetails();
    await emit.forEach<GetAllChatsDetailsResult>(
      payloadStream.getPayload,
      onData: (GetAllChatsDetailsResult result) {
        return result.map(
          success: (result) => AllChatsState.content(
            details: result.details,
            currentUserId: user.id,
            currentUserName: user.name,
          ),
          failure: (_) {
            payloadStream.dispose();
            return const AllChatsState.failure();
          },
        );
      },
    );
  }

  FutureOr<void> _onProfilePressed(ProfilePressedAllChatEvent event, Emitter<AllChatsState> emit) {
    emit.sync(state, const AllChatsState.openProfile());
  }
}

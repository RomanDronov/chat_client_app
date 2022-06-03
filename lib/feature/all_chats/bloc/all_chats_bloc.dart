import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

import '../../../core/data/socket_provider.dart';
import '../../../core/data/user_repository.dart';
import '../../../core/domain/location/location_service.dart';
import '../../../core/domain/location/models/get_current_location_result.dart';
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
  final LocationService _locationService;
  final SocketProvider _socketProvider;
  AllChatsBloc(
    this._service,
    this._userRepository,
    this._locationService,
    this._socketProvider,
  ) : super(const AllChatsState.loading()) {
    on<InitializedAllChatsEvent>(_onInitialized);
    on<RecipientPressedAllChatsEvent>(_onUserPressed);
    on<ProfilePressedAllChatEvent>(_onProfilePressed);
    on<GroupChatPressedAllChatEvent>(_onGroupChatPressed);
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
    _socketProvider.initialize(user.id);
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

  FutureOr<void> _onGroupChatPressed(
    GroupChatPressedAllChatEvent event,
    Emitter<AllChatsState> emit,
  ) async {
    final GetCurrentLocationResult result = await _locationService.getCurrentLocation();
    result.when(
      success: (Position position) {
        emit.sync(state, AllChatsState.openGroupChat(position: position));
      },
      disabled: () {
        emit.sync(state, const AllChatsState.showLocationDisabledAlert());
      },
      denied: () {
        emit.sync(state, const AllChatsState.showLocationPermissionAlert());
      },
      deniedForever: () {
        emit.sync(state, const AllChatsState.showLocationPermissionAlert());
      },
      unknownFailure: () {
        emit.sync(state, const AllChatsState.showUnknownFailureAlert());
      },
    );
  }
}

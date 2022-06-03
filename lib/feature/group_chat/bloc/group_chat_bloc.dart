import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../core/data/config_repository.dart';
import '../../../core/data/socket_provider.dart';
import '../../../core/data/user_repository.dart';
import '../../../models/chat_user.dart';
import '../../../models/gender.dart';
import '../../../utils/emitter_extensions.dart';
import '../../all_chats/models/data/all_chats_response.dart';
import '../../all_chats/models/domain/all_chats_details.dart';

part 'group_chat_bloc.freezed.dart';
part 'group_chat_event.dart';
part 'group_chat_state.dart';

class GroupChatBloc extends Bloc<GroupChatEvent, GroupChatState> {
  final UserRepository _userRepository;
  final SocketProvider _socketProvider;
  List<Message> messages = [];
  late io.Socket socket;
  bool isLoading = true;
  late Author currentUser;
  GroupChatBloc(this._userRepository, this._socketProvider)
      : super(const GroupChatState.loading()) {
    on<InitializedGroupChatEvent>(_onInitialized);
    on<NewMessageGroupChatEvent>(_onNewMessage);
    on<SendMessageGroupChatEvent>(_onSendMessage);
  }

  FutureOr<void> _sendMessage(String text) async {
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }
    socket.emit(
      'send_message_global',
      json.encode(
        MessageDto(
          AuthorDto(
            currentUser.name,
            currentUser.id,
            currentUser.gender.name,
            DateTime.now().toUtc(),
          ),
          MessageContentDto(
            text,
          ),
          DateTime.now().toUtc(),
        ).toJson(),
      ),
    );
  }

  Future<void> _prepareSocket(Position position) async {
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }

    socket = _socketProvider.socket!;

    socket.on('receive_message_global', (jsonData) {
      final MessageDto message = MessageDto.fromJson(jsonData);
      if (!isClosed) {
        add(
          GroupChatEvent.newMessage(
            message: Message(
              author: Author(
                name: message.author.name,
                id: message.author.id,
                gender: getGenderByCodeOrElse(message.author.gender, Gender.cat),
                lastOnline: message.author.lastOnline,
              ),
              content: MessageContent(text: message.content.text),
              sentDateTime: message.sentDateTimeUtc,
            ),
          ),
        );
      }
    });

    socket.emit(
      'join_chat_global',
      json.encode(
        {
          'userId': currentUser.id,
          'position': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
        },
      ),
    );
  }

  FutureOr<void> _onInitialized(
    InitializedGroupChatEvent event,
    Emitter<GroupChatState> emit,
  ) async {
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }
    this.currentUser = Author(
      name: currentUser.name,
      id: currentUser.id,
      gender: currentUser.gender,
      lastOnline: DateTime.now().toUtc(),
    );
    await _prepareSocket(event.position);
    emit(GroupChatState.content(content: ChatContent(messages), currentUserId: currentUser.id));
  }

  FutureOr<void> _onNewMessage(NewMessageGroupChatEvent event, Emitter<GroupChatState> emit) {
    messages.add(event.message);
    final contentState = GroupChatState.content(
      content: ChatContent(List.from(messages, growable: false)),
      currentUserId: currentUser.id,
    );
    final scrollState = GroupChatState.scrollToIndex(index: messages.length - 1);
    emit.sync(contentState, scrollState);
  }

  FutureOr<void> _onSendMessage(
    SendMessageGroupChatEvent event,
    Emitter<GroupChatState> emit,
  ) async {
    final String text = event.text.trim();
    if (text.isEmpty) {
      return;
    }
    await _sendMessage(text);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../core/data/config_repository.dart';
import '../../../core/data/socket_provider.dart';
import '../../../core/data/user_repository.dart';
import '../../../models/chat_user.dart';
import '../../../utils/emitter_extensions.dart';
import '../../all_chats/models/domain/all_chats_details.dart';
import '../models/data/message_dto.dart';

part 'chat_bloc.freezed.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserRepository _userRepository;
  final SocketProvider _socketProvider;
  final ConfigRepository _configRepository;
  List<Message> messages = [];
  late io.Socket socket;
  bool isLoading = true;
  late Author recipient;
  late Author currentUser;
  late String chatId;
  ChatBloc(
    this._userRepository,
    this._socketProvider,
    this._configRepository,
  ) : super(const ChatState.loading()) {
    on<InitializedChatEvent>(_onInitialized);
    on<NewMessageChatEvent>(_onNewMessage);
    on<SendMessageChatEvent>(_onSendMessage);
  }

  FutureOr<void> _sendMessage(String text) async {
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }
    socket.emit(
      'send_message',
      json.encode(
        {
          'chatId': chatId,
          'userId': currentUser.id,
          'recipientId': recipient.id,
          'content': text,
        },
      ),
    );
  }

  Future<void> _prepareSocket() async {
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }

    socket = _socketProvider.socket!;

    socket.on('receive_message', (jsonData) {
      final MessageDto message = MessageDto.fromJson(jsonData);
      if (!isClosed) {
        add(
          ChatEvent.newMessage(
            message: Message(
              author: currentUser.id == message.userId
                  ? Author(
                      name: currentUser.name,
                      id: currentUser.id,
                      gender: currentUser.gender,
                      lastOnline: DateTime.now(),
                    )
                  : recipient,
              content: MessageContent(text: message.content),
              sentDateTime: DateTime.now(),
            ),
          ),
        );
      }
    });

    socket.emit(
      'join_chat',
      json.encode(
        {
          'chatId': chatId,
          'userId': currentUser.id,
          'recipientId': recipient.id,
        },
      ),
    );
  }

  FutureOr<void> _onInitialized(InitializedChatEvent event, Emitter<ChatState> emit) async {
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
    recipient = event.recipient;
    if (event.chatId == null) {
      final http.Response response = await http.get(
        Uri.parse(
          '${_configRepository.getChatHost()}/get-chat-id?userId=${currentUser.id}&recipientId=${recipient.id}',
        ),
      );
      chatId = jsonDecode(response.body)['chatId'];
    } else {
      chatId = event.chatId!;
    }
    await _prepareSocket();
    emit(ChatState.content(content: ChatContent(messages), currentUserId: currentUser.id));
  }

  FutureOr<void> _onNewMessage(NewMessageChatEvent event, Emitter<ChatState> emit) {
    messages.add(event.message);
    final contentState = ChatState.content(
      content: ChatContent(List.from(messages, growable: false)),
      currentUserId: currentUser.id,
    );
    final scrollState = ChatState.scrollToIndex(index: messages.length - 1);
    emit.sync(contentState, scrollState);
  }

  FutureOr<void> _onSendMessage(SendMessageChatEvent event, Emitter<ChatState> emit) async {
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

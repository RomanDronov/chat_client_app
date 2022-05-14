import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../core/data/config_repository.dart';
import '../../../core/data/user_repository.dart';
import '../../../models/chat_user.dart';
import '../../../models/message.dart';
import '../../../utils/emitter_extensions.dart';

part 'chat_bloc.freezed.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserRepository _userRepository;
  final ConfigRepository _configRepository;
  List<Message> messages = <Message>[];
  late io.Socket socketIO;
  bool isLoading = true;
  late ChatUser receiver;
  late ChatUser currentUser;
  ChatBloc(this._userRepository, this._configRepository) : super(const ChatState.loading()) {
    on<InitializedChatEvent>(_onInitialized);
    on<NewMessageChatEvent>(_onNewMessage);
    on<SendMessageChatEvent>(_onSendMessage);
  }

  FutureOr<void> _sendMessage(String text) async {
    final String receiverChatID = receiver.id;
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }
    socketIO.emit(
      'send_message',
      json.encode(
        {
          'receiverChatID': receiverChatID,
          'senderChatID': currentUser.id,
          'content': text,
        },
      ),
    );
  }

  List<Message> getMessagesForChatID(String chatID) {
    return messages.where((msg) => msg.senderID == chatID || msg.receiverID == chatID).toList();
  }

  Future<void> _prepareSocket() async {
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }

    socketIO = io.io(
      _configRepository.getChatHost(),
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'chatId': currentUser.id})
          .build(),
    );

    socketIO.on('receive_message', (jsonData) {
      final Message message =
          Message(jsonData['content'], jsonData['senderChatID'], jsonData['receiverChatID']);
      add(ChatEvent.newMessage(message: message));
    });

    socketIO.connect();
  }

  FutureOr<void> _onInitialized(InitializedChatEvent event, Emitter<ChatState> emit) async {
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }
    this.currentUser = currentUser;
    receiver = event.receiver;
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
}

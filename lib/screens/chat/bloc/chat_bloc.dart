import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../data/user_repository.dart';
import '../../../models/chat_user.dart';
import '../../../models/message.dart';
import '../../../utils/emitter_extensions.dart';

part 'chat_bloc.freezed.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserRepository _userRepository;
  List<Message> messages = <Message>[];
  late io.Socket socketIO;
  final serverUrl = 'http://127.0.0.1:3000';
  bool isLoading = true;
  late ChatUser receiver;
  late ChatUser currentUser;
  ChatBloc(this._userRepository) : super(const ChatState.loading()) {
    on<InitializedChatEvent>(_onInitialized);
    on<NewMessageChatEvent>(_onNewMessage);
    on<SendMessageChatEvent>(_onSendMessage);
  }

  FutureOr<void> _sendMessage(String text) async {
    final String receiverChatID = receiver.chatID;
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }
    socketIO.emit(
      'send_message',
      json.encode(
        {
          'receiverChatID': receiverChatID,
          'senderChatID': currentUser.chatID,
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
      serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .setExtraHeaders({'chatId': currentUser.chatID}) // optional
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
    emit(ChatState.content(content: ChatContent(messages), currentUserId: currentUser.chatID));
  }

  FutureOr<void> _onNewMessage(NewMessageChatEvent event, Emitter<ChatState> emit) {
    messages.add(event.message);
    final contentState = ChatState.content(
      content: ChatContent(List.from(messages, growable: false)),
      currentUserId: currentUser.chatID,
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

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../data/user_repository.dart';
import '../../../models/chat_user.dart';
import '../../../models/message.dart';

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
  ChatBloc(this._userRepository) : super(ChatState.loading()) {
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
    messages.add(Message(text, currentUser.chatID, receiverChatID));
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

    socketIO = io.io('$serverUrl', {
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socketIO.on('receive_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      final Message message =
          Message(data['content'], data['senderChatID'], data['receiverChatID']);
      add(ChatEvent.newMessage(message: message));
    });

    socketIO.connect();
    socketIO.onConnect((data) => print('Connected'));
    print('Connected: ${socketIO.connected}');
  }

  FutureOr<void> _onInitialized(InitializedChatEvent event, Emitter<ChatState> emit) async {
    final ChatUser? currentUser = await _userRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }
    receiver = event.receiver;
    await _prepareSocket();
    emit(ChatState.content(messages: messages, currentUserId: currentUser.chatID));
  }

  FutureOr<void> _onNewMessage(NewMessageChatEvent event, Emitter<ChatState> emit) {
    messages.add(event.message);
  }

  FutureOr<void> _onSendMessage(SendMessageChatEvent event, Emitter<ChatState> emit) async {
    await _sendMessage(event.text);
  }
}

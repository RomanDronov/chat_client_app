import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../core/data/config_repository.dart';
import '../../../core/util/stream_socket.dart';
import '../models/data/all_chats_response.dart';
import '../models/domain/get_all_chats_details_result.dart';

class AllChatsRepository {
  final ConfigRepository _configRepository;

  AllChatsRepository(this._configRepository);

  Future<PayloadStream<GetAllChatsDetailsResult>> subscribeToDetails({
    required String currentUserId,
  }) async {
    PayloadStream<GetAllChatsDetailsResult> payloadStream = PayloadStream();
    final io.Socket socket = io.io(
      _configRepository.getChatHost(),
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'userId': currentUserId})
          .build(),
    );

    socket.onConnect((data) {
      socket.emit(
        'get_chat_list',
        jsonEncode(
          {
            'userId': currentUserId,
          },
        ),
      );
    });

    socket.on(
      'send_chat_list',
      (jsonData) {
        final Map<String, dynamic> rawResponse = jsonDecode(jsonData);
        final GetAllChatsResponse response = GetAllChatsResponse.fromJson(rawResponse);
        final GetAllChatsDetailsResult result = response.toDomain();
        payloadStream.addPayload(result);
      },
    );

    socket.onError((data) => payloadStream.addPayload(const GetAllChatsDetailsResult.failure()));

    socket.onConnectTimeout(
      (data) => payloadStream.addPayload(const GetAllChatsDetailsResult.failure()),
    );
    socket.onDisconnect((data) {
      payloadStream.addPayload(const GetAllChatsDetailsResult.failure());
      payloadStream.dispose();
    });

    socket.connect();

    return payloadStream;
  }
}

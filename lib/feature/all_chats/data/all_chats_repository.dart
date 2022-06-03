import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../core/data/socket_provider.dart';
import '../../../core/util/stream_socket.dart';
import '../models/data/all_chats_response.dart';
import '../models/domain/get_all_chats_details_result.dart';

class AllChatsRepository {
  final SocketProvider _socketProvider;

  AllChatsRepository(this._socketProvider);

  Future<PayloadStream<GetAllChatsDetailsResult>> subscribeToDetails({
    required String currentUserId,
  }) async {
    PayloadStream<GetAllChatsDetailsResult> payloadStream = PayloadStream();
    final io.Socket socket = _socketProvider.socket!;

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

    socket.onError((data) {
      payloadStream.addPayload(const GetAllChatsDetailsResult.failure());
    });

    socket.onConnectTimeout(
      (data) {
        payloadStream.addPayload(const GetAllChatsDetailsResult.failure());
      },
    );
    socket.onDisconnect((data) {
      payloadStream.addPayload(const GetAllChatsDetailsResult.failure());
      payloadStream.dispose();
    });

    return payloadStream;
  }
}

import 'package:socket_io_client/socket_io_client.dart' as io;

import 'config_repository.dart';

class SocketProvider {
  final ConfigRepository _configRepository;
  io.Socket? _socket;

  SocketProvider(this._configRepository);

  io.Socket? get socket => _socket;

  void initialize(String currentUserId) {
    _socket?.disconnect();
    _socket = io.io(
      _configRepository.getChatHost(),
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setReconnectionAttempts(5)
          .setExtraHeaders({'userId': currentUserId})
          .build(),
    );
  }
}

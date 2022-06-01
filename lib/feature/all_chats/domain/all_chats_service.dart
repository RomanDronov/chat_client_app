import 'dart:async';

import '../../../core/data/user_repository.dart';
import '../../../core/util/stream_socket.dart';
import '../../../models/chat_user.dart';
import '../data/all_chats_repository.dart';
import '../models/domain/get_all_chats_details_result.dart';

class AllChatsService {
  final UserRepository _userRepository;
  final AllChatsRepository _allChatsRepository;

  AllChatsService(this._userRepository, this._allChatsRepository);

  Future<PayloadStream<GetAllChatsDetailsResult>> subscribeToDetails() async {
    final ChatUser currentUser = await _userRepository.getCurrentUser(isForce: true);
    return _allChatsRepository.subscribeToDetails(currentUserId: currentUser.id);
  }
}

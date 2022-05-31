import 'package:freezed_annotation/freezed_annotation.dart';

import 'all_chats_details.dart';

part 'get_all_chats_details_result.freezed.dart';

@freezed
class GetAllChatsDetailsResult with _$GetAllChatsDetailsResult {
  const factory GetAllChatsDetailsResult.success({
    required AllChatsDetails details,
  }) = SuccessGetAllChatsDetailsResult;
  const factory GetAllChatsDetailsResult.failure() = FailureGetAllChatsDetailsResult;
}

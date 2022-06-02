import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'get_current_location_result.freezed.dart';

@freezed
class GetCurrentLocationResult with _$GetCurrentLocationResult {
  const factory GetCurrentLocationResult.success({
    required Position position,
  }) = SuccessGetCurrentLocationResult;
  const factory GetCurrentLocationResult.disabled() = DisabledGetCurrentLocationResult;
  const factory GetCurrentLocationResult.denied() = DeniedGetCurrentLocationResult;
  const factory GetCurrentLocationResult.deniedForever() = DeniedForeverGetCurrentLocationResult;
  const factory GetCurrentLocationResult.unknownFailure() = UnknownFailureGetCurrentLocationResult;
}

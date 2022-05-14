import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import '../../main.dart';

class ConfigRepository {
  final Logger _logger;
  final FirebaseRemoteConfig _remoteConfig;

  ConfigRepository(this._logger, this._remoteConfig);
  Future<void> initialize() async {
    final Map<String, dynamic> defaultParameters = {
      'chat_host': 'https://127.0.0.1:3000',
    };
    try {
      await _remoteConfig.setDefaults(defaultParameters);
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: Duration.zero,
        ),
      );
      await _remoteConfig.fetchAndActivate();
    } on PlatformException catch (exception) {
      _logger.w(
        'Could not load remote config. Default values will be used',
        exception,
      );
    } catch (exception) {
      _logger.w(
        'Could not load remote config. Default values will be used',
        exception,
      );
    }
  }

  String getChatHost() {
    return _getString('chat_host');
  }

  String _getString(String parameter) {
    final String value = _remoteConfig.getString(parameter);
    logger.i('Config Parameter requested: $parameter = "$value"');
    return value;
  }
}

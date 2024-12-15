import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/preference_config.dart';

//* Request methods PUT, POST, PATCH, DELETE needs access token,
//* which needs to be passed with "Authorization" header as Bearer token.
class AuthorizationInterceptor extends QueuedInterceptor {
  static const _headerKeyAuthorization = 'Authorization';
  static const _headerKeyAuthorizationBearerPrefix = 'Bearer ';

  Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(PreferenceConfig.accessTokenPref);
    options.headers[_headerKeyAuthorization] =
        '$_headerKeyAuthorizationBearerPrefix$accessToken';

    logger.i('Headers => ${options.headers}');
    super.onRequest(options, handler);
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/preference_config.dart';
import '../../../localdb/isar_service.dart';
import '../../../localdb/user/db_user.dart';
import '../../../network/dio_client.dart';
import '../../../utils/static_functions.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _dio = DioClient();
  final _isarService = IsarService();
  late SharedPreferences _preferences;
  final String _clientId = "Ov23linhfHRX4FZwMctz";
  final String _clientSecret = "5b6b4f6a506a17017300f33b8438759aca49b90e";
  final String _redirectUri = "myapp://callback";

  AuthBloc() : super(AuthInitialState()) {
    on<AuthInitialEvent>(_init);
    on<AuthStartEvent>(_authenticate);
    on<AuthCodeFoundEvent>(_authCodeFoundEvent);
    add(AuthInitialEvent());
  }

  Future<void> _init(
    AuthInitialEvent event,
    Emitter<AuthState> emit,
  ) async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> _authCodeFoundEvent(
    AuthCodeFoundEvent event,
    Emitter<AuthState> emit,
  ) async {
    final authCode = event.authCode;
    if (authCode != null) {
      emit(AuthLoadingState());
      final result = await DioClient.exchangeTokenApi().authenticateAccessToken(
        clientId: _clientId,
        clientSecret: _clientSecret,
        code: authCode,
        redirectUrl: _redirectUri,
      );

      if (result?.accessToken != null) {
        await _preferences.setString(
          PreferenceConfig.accessTokenPref,
          result!.accessToken,
        );
        final isSuccess = await _fetchUserInfo();
        if (isSuccess) {
          emit(AuthSuccessState());
        } else {
          emit(AuthFailedState());
        }
      } else {
        emit(AuthFailedState());
      }
    } else {
      emit(AuthFailedState());
    }
  }

  Future<bool> _fetchUserInfo() async {
    final result = await _dio.fetchUserInfo();
    if (result != null) {
      final userId = result.id?.toInt() ?? StaticFunctions.defaultUserId;
      final userInfo = DbUser()
        ..userId = userId
        ..login = result.login
        ..name = result.name
        ..accessToken = _preferences.getString(
          PreferenceConfig.accessTokenPref,
        )
        ..avatarUrl = result.avatarUrl
        ..email = result.email;
      await _preferences.setInt(
        PreferenceConfig.userIdPref,
        userId,
      );
      await _isarService.saveOrUpdateUserInfo(
        userInfo,
      );
      StaticFunctions.userInfo = userInfo;
      return true;
    }
    return false;
  }

  Future<void> _authenticate(
    AuthStartEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final url =
        "https://github.com/login/oauth/authorize?client_id=$_clientId&redirect_uri=$_redirectUri&scope=read:user,user:email";

    try {
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: "myapp",
      );
      emit(AuthLoadingState(
        isLoading: false,
      ));
      final code = Uri.parse(result).queryParameters['code'];
      debugPrint('Code:: $code');
    } catch (e) {
      emit(AuthLoadingState(
        isLoading: false,
      ));
      debugPrint('Exception:: $e');
    }
  }
}

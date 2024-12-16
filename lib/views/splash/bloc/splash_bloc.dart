import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_config.dart';
import '../../../config/preference_config.dart';
import '../../../const/routes.dart';
import '../../../localdb/isar_service.dart';
import '../../../utils/static_functions.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitialState()) {
    on<SplashInitialEvent>(_initialEvent);
    add(SplashInitialEvent());
  }

  _initialEvent(
    SplashInitialEvent event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(const Duration(seconds: AppConfig.splashDuration));
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(PreferenceConfig.accessTokenPref);
    final userId = prefs.getInt(PreferenceConfig.userIdPref);
    if (userId == null || accessToken == null || accessToken.trim().isEmpty) {
      emit(SplashNavigationState(Routes.authentication));
    } else {
      final userInfo = await IsarService().getUserInfo();
      if (userInfo != null) {
        StaticFunctions.userInfo = userInfo;
        emit(SplashNavigationState(Routes.home));
      } else {
        prefs.clear();
        emit(SplashNavigationState(Routes.authentication));
      }
    }
  }
}

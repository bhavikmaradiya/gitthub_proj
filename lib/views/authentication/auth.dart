import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gitthub_proj/config/light_colors_config.dart';
import 'package:gitthub_proj/network/network_connectivity.dart';
import 'package:gitthub_proj/views/authentication/bloc/auth_bloc.dart';
import '../../config/app_config.dart';
import '../../const/assets.dart';
import '../../const/dimens.dart';
import '../../const/routes.dart';
import '../../const/strings.dart';
import '../../utils/loading_progress.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  AuthBloc? _authBloc;
  AppLocalizations? _appLocalizations;
  static const _platform = MethodChannel(Strings.methodChannel);

  @override
  void initState() {
    super.initState();
    _platform.setMethodCallHandler((call) async {
      if (call.method == "onAuthCodeReceived") {
        final authCode = call.arguments;
        _authBloc?.add(
          AuthCodeFoundEvent(
            authCode,
          ),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appLocalizations ??= AppLocalizations.of(context)!;
    _authBloc ??= BlocProvider.of<AuthBloc>(context, listen: false);
  }

  void _listenAuthChanges(context, state) {
    LoadingProgress.showHideProgress(
      context,
      state is AuthLoadingState && state.isLoading,
    );
    if (state is AuthSuccessState) {
      Navigator.pushReplacementNamed(
        context,
        Routes.home,
      );
    } else if (state is AuthFailedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _appLocalizations!.authError,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimens.dimens_15.sp,
            ),
          ),
          duration: const Duration(
            seconds: AppConfig.defaultSnackBarDuration,
          ),
        ),
      );
    }
  }

  Future<void> _startAuthentication() async {
    final isNetWorkAvailable = await NetworkConnectivity.hasNetwork();
    if (isNetWorkAvailable) {
      _authBloc?.add(
        AuthStartEvent(),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _appLocalizations!.noInternet,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimens.dimens_15.sp,
            ),
          ),
          duration: const Duration(
            seconds: AppConfig.defaultSnackBarDuration,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (_, current) =>
          current is AuthSuccessState ||
          current is AuthFailedState ||
          current is AuthLoadingState,
      listener: _listenAuthChanges,
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                color: LightColorsConfig.lightBlackColor,
                borderRadius: BorderRadius.circular(
                  Dimens.dimens_10.r,
                ),
                border: Border.all(
                  color: LightColorsConfig.lightWhiteColor,
                )),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _startAuthentication(),
                borderRadius: BorderRadius.circular(
                  Dimens.dimens_10.r,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.dimens_12.w,
                    vertical: Dimens.dimens_6.w,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        Assets.icGithub,
                        width: Dimens.dimens_36.w,
                        height: Dimens.dimens_36.w,
                        color: LightColorsConfig.lightWhiteColor,
                      ),
                      SizedBox(
                        width: Dimens.dimens_10.w,
                      ),
                      Text(
                        _appLocalizations!.signInWithGithub,
                        style: TextStyle(
                          color: LightColorsConfig.lightWhiteColor,
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.dimens_16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

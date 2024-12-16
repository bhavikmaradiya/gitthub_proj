import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/light_colors_config.dart';
import '../../const/assets.dart';
import '../../const/dimens.dart';
import '../../const/routes.dart';
import './bloc/splash_bloc.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return BlocListener<SplashBloc, SplashState>(
      listenWhen: (previous, current) =>
          previous != current && current is! SplashInitialState,
      listener: (context, state) {
        if (state is SplashNavigationState) {
          final route = state.routeName;
          switch (route) {
            case Routes.authentication:
              _navigateToAuthentication(context);
              break;
            case Routes.home:
              _navigateToHome(context);
              break;
            default:
              _navigateToAuthentication(context);
              break;
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.icGithub150,
                  height: Dimens.dimens_150.w,
                  width: Dimens.dimens_150.w,
                ),
                SizedBox(
                  height: Dimens.dimens_10.h,
                ),
                Text(
                  appLocalizations.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: Dimens.dimens_40.sp,
                  ),
                ),
                SizedBox(
                  height: Dimens.dimens_10.h,
                ),
                Text(
                  appLocalizations.githubSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w700,
                    fontSize: Dimens.dimens_15.sp,
                  ),
                ),
                SizedBox(
                  height: Dimens.dimens_50.h,
                ),
                CircularProgressIndicator(
                  color: LightColorsConfig.lightWhiteColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _navigateToAuthentication(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      Routes.authentication,
    );
  }

  _navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      Routes.home,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gitthub_proj/const/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'config/app_config.dart';
import 'config/theme_config.dart';
import 'const/strings.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        AppConfig.figmaScreenWidth,
        AppConfig.figmaScreenHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale(Strings.englishLocale, ''),
        ],
        routes: Routes.routeList,
        navigatorKey: navigatorKey,
        themeMode: ThemeMode.light,
        theme: ThemeConfig.lightTheme,
        initialRoute: Routes.splash,
      ),
    );
  }
}

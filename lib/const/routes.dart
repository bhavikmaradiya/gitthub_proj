import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitthub_proj/views/home/bloc/home_bloc.dart';

import '../views/authentication/auth.dart';
import '../views/authentication/bloc/auth_bloc.dart';
import '../views/home/home.dart';
import '../views/splash/bloc/splash_bloc.dart';
import '../views/splash/splash.dart';

class Routes {
  static const String splash = '/splash';
  static const String authentication = '/authentication';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routeList => {
        splash: (_) => BlocProvider<SplashBloc>(
              create: (_) => SplashBloc(),
              child: const Splash(),
            ),
        authentication: (_) => BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(),
              child: const Auth(),
            ),
        home: (_) => BlocProvider<HomeBloc>(
              create: (_) => HomeBloc(),
              child: const Home(),
            ),
      };
}

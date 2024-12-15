import 'package:flutter/material.dart';

import './light_colors_config.dart';

class ThemeConfig {
  static const appFonts = 'DMSans';

  static ThemeData lightTheme = ThemeData(
    primaryColor: LightColorsConfig.themeColor,
    fontFamily: appFonts,
    scaffoldBackgroundColor: LightColorsConfig.scaffoldColor,
    brightness: Brightness.light,
    useMaterial3: true,
  );
}

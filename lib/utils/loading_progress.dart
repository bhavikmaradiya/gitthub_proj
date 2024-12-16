import 'package:flutter/material.dart';

import '../config/light_colors_config.dart';

class LoadingProgress {
  static bool _isDialogShowing = false;

  static showHideProgress(
    BuildContext context,
    bool isLoading,
  ) {
    if (isLoading && !_isDialogShowing) {
      _isDialogShowing = true;
      showGeneralDialog(
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: isLoading
                  ? AbsorbPointer(
                      child: CircularProgressIndicator(
                        color: LightColorsConfig.lightWhiteColor,
                      ),
                    )
                  : const SizedBox(),
            ),
          );
        },
      );
    } else {
      if (_isDialogShowing) {
        _isDialogShowing = false;
        Navigator.pop(context);
      }
    }
  }
}

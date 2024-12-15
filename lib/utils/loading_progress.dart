import 'package:flutter/material.dart';

class LoadingProgress {
  static bool _isDialogShowing = false;

  static showHideProgress(BuildContext context, bool isLoading) {
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
                  ? const AbsorbPointer(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
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

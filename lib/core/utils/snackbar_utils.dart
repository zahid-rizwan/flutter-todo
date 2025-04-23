import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

enum SnackBarType { success, error, info, warning }

class SnackBarUtils {
  static void showSnackBar(
      BuildContext context, {
        required String message,
        SnackBarType type = SnackBarType.info,
        Duration duration = const Duration(seconds: 3),
      }) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: _getSnackBarColor(type),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      duration: duration,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color _getSnackBarColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return AppColors.success;
      case SnackBarType.error:
        return AppColors.error;
      case SnackBarType.warning:
        return AppColors.warning;
      case SnackBarType.info:
        return AppColors.info;
    }
  }
}

extension SnackBarUtilsExtension on BuildContext {
  void showSuccessSnackBar(String message) {
    SnackBarUtils.showSnackBar(
      this,
      message: message,
      type: SnackBarType.success,
    );
  }

  void showErrorSnackBar(String message) {
    SnackBarUtils.showSnackBar(
      this,
      message: message,
      type: SnackBarType.error,
    );
  }

  void showInfoSnackBar(String message) {
    SnackBarUtils.showSnackBar(
      this,
      message: message,
      type: SnackBarType.info,
    );
  }

  void showWarningSnackBar(String message) {
    SnackBarUtils.showSnackBar(
      this,
      message: message,
      type: SnackBarType.warning,
    );
  }
}
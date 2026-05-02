import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scaffoldMessengerKeyProvider = Provider((ref) => GlobalKey<ScaffoldMessengerState>());

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final key = ref.watch(scaffoldMessengerKeyProvider);
  return NotificationService(key);
});

class NotificationService {
  final GlobalKey<ScaffoldMessengerState> _messengerKey;

  NotificationService(this._messengerKey);

  void showSuccess(String message) {
    _messengerKey.currentState?.clearSnackBars();
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    HapticFeedback.mediumImpact();
  }

  void showError(String message) {
    _messengerKey.currentState?.clearSnackBars();
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
    HapticFeedback.vibrate();
  }

  void showInfo(String message) {
    _messengerKey.currentState?.clearSnackBars();
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

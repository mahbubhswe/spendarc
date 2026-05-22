import 'dart:async';

import 'package:flutter/material.dart';

class UndoSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    required VoidCallback onUndo,
    String actionLabel = 'UNDO',
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    var isRestored = false;

    messenger.hideCurrentSnackBar();

    late final ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
    snackBarController;

    snackBarController = messenger.showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        content: _UndoSnackBarContent(message: message, duration: duration),
        action: SnackBarAction(
          label: actionLabel,
          onPressed: () {
            isRestored = true;
            onUndo();
            snackBarController.close();
          },
        ),
      ),
    );

    Timer(duration, () {
      if (!isRestored) {
        snackBarController.close();
      }
    });
  }

  static void showTransactionDeleted({
    required BuildContext context,
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: 'This transaction has been deleted',
      onUndo: onUndo,
      duration: duration,
    );
  }
}

class _UndoSnackBarContent extends StatelessWidget {
  final String message;
  final Duration duration;

  const _UndoSnackBarContent({required this.message, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1, end: 0),
            duration: duration,
            curve: Curves.linear,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 3,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              );
            },
          ),
        ),
      ],
    );
  }
}

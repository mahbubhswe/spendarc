import 'package:flutter/material.dart';

class AppSnackBar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    return messenger.showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        content: _AppSnackBarContent(message: message, duration: duration),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(label: actionLabel, onPressed: onAction)
            : null,
      ),
    );
  }
}

class _AppSnackBarContent extends StatelessWidget {
  final String message;
  final Duration duration;

  const _AppSnackBarContent({required this.message, required this.duration});

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

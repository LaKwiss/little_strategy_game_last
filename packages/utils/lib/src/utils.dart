import 'package:flutter/material.dart';

class Utils {
  static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'settings':
        return Icons.settings;
      case 'exit':
        return Icons.exit_to_app;
      case 'science':
        return Icons.science;
      case 'psychology':
        return Icons.psychology;
      case 'gamepad':
        return Icons.gamepad;
      case 'bolt':
        return Icons.bolt;
      default:
        return Icons.error;
    }
  }

  static Future<T> safeExecute<T>(
      Future<T> Function() operation, String operationName) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      print('Error during $operationName: $e');
      print(stackTrace);
      rethrow;
    }
  }
}

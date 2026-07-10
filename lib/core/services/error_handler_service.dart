library error_handler_service;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../errors/app_errors.dart';
import '../../main.dart'; // For rootScaffoldMessengerKey

/// Service for handling and displaying errors throughout the app
class ErrorHandlerService {
  /// Handle error and show appropriate user message
  void handleError(AppError error, {bool showSnackBar = true}) {
    // Log error (in production, this would go to crashlytics/sentry)
    debugPrint('🔴 ${error.type.name.toUpperCase()}: ${error.message}');
    if (error.details != null) {
      debugPrint('Details: ${error.details}');
    }

    if (showSnackBar) {
      _showUserErrorMessage(error);
    }
  }

  /// Handle generic exceptions and convert them to AppErrors
  void handleException(dynamic exception, {
    String? context,
    bool showSnackBar = true,
  }) {
    AppError error;
    
    if (exception is AppError) {
      error = exception;
    } else {
      // Convert generic exception to AppError
      error = _convertExceptionToAppError(exception, context);
    }
    
    handleError(error, showSnackBar: showSnackBar);
  }

  /// Show user-friendly error message
  void _showUserErrorMessage(AppError error) {
    try {
      final scaffoldMessenger = rootScaffoldMessengerKey.currentState;
      if (scaffoldMessenger != null) {
        final message = _getUserFriendlyMessage(error);
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  _getErrorIcon(error.type),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(message)),
                if (error.isRetryable) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      scaffoldMessenger.hideCurrentSnackBar();
                      // TODO: Add retry logic
                    },
                    child: const Text(
                      'RETRY',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
            backgroundColor: _getErrorColor(error.type),
            duration: Duration(seconds: error.isRetryable ? 5 : 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Silently handle cases where UI context is not available
      debugPrint('Could not show error message: $e');
    }
  }

  /// Convert generic exception to AppError
  AppError _convertExceptionToAppError(dynamic exception, String? context) {
    final message = context != null 
        ? '$context: ${exception.toString()}' 
        : exception.toString();
    
    if (exception.toString().contains('SocketException') || 
        exception.toString().contains('TimeoutException')) {
      return NetworkError.now(
        message: 'Network connection failed',
        details: message,
        isRetryable: true,
      );
    }
    
    if (exception.toString().contains('FormatException')) {
      return ValidationError.now(
        message: 'Invalid data format',
        details: message,
      );
    }
    
    return BusinessError.now(
      message: 'An unexpected error occurred',
      details: message,
      isRetryable: false,
    );
  }

  /// Get user-friendly error message
  String _getUserFriendlyMessage(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        return 'Network connection problem. Check your internet connection.';
      case ErrorType.validation:
        return error.message; // Validation messages are already user-friendly
      case ErrorType.repository:
        return 'Failed to save data. Please try again.';
      case ErrorType.authentication:
        return 'Authentication failed. Please log in again.';
      case ErrorType.permission:
        return 'Permission needed. Please enable required permissions.';
      case ErrorType.business:
        return error.message; // Business errors are usually user-friendly
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Get appropriate icon for error type
  IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.validation:
        return Icons.warning;
      case ErrorType.authentication:
        return Icons.lock;
      case ErrorType.permission:
        return Icons.security;
      default:
        return Icons.error;
    }
  }

  /// Get appropriate color for error type
  Color _getErrorColor(ErrorType type) {
    switch (type) {
      case ErrorType.validation:
        return Colors.orange;
      case ErrorType.network:
        return Colors.red[700]!;
      case ErrorType.authentication:
        return Colors.purple[700]!;
      case ErrorType.permission:
        return Colors.blue[700]!;
      default:
        return Colors.red;
    }
  }
}

/// Error handler service provider
final errorHandlerServiceProvider = Provider<ErrorHandlerService>((ref) {
  return ErrorHandlerService();
});

/// Global error boundary function
void handleGlobalError(dynamic error, StackTrace stackTrace, {String? context}) {
  // In a real app, you'd also send this to crash reporting service
  debugPrint('🔴 GLOBAL ERROR: $error');
  debugPrint('Stack trace: $stackTrace');
  
  // Could show a global error dialog or crash screen
}
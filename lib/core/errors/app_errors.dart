library app_errors;

/// Base class for all application errors
abstract class AppError {
  final String message;
  final String? details;
  final ErrorType type;
  final bool isRetryable;
  final DateTime timestamp;

  AppError.now({
    required this.message,
    this.details,
    required this.type,
    this.isRetryable = false,
  }) : timestamp = DateTime.now();

  @override
  String toString() => 'AppError($type): $message${details != null ? '\nDetails: $details' : ''}';
}

enum ErrorType {
  // Data layer errors
  repository,
  database,
  storage,
  
  // Network errors
  network,
  api,
  timeout,
  
  // Validation errors
  validation,
  authentication,
  authorization,
  
  // Business logic errors
  business,
  achievement,
  quest,
  
  // System errors
  platform,
  permission,
  unknown,
}

/// Repository-related errors
class RepositoryError extends AppError {
  RepositoryError.now({
    required String message,
    String? details,
    bool isRetryable = false,
  }) : super.now(
          message: message,
          details: details,
          type: ErrorType.repository,
          isRetryable: isRetryable,
        );
}

/// Network-related errors
class NetworkError extends AppError {
  final int? statusCode;
  
  NetworkError.now({
    required String message,
    String? details,
    this.statusCode,
    bool isRetryable = true,
  }) : super.now(
          message: message,
          details: details,
          type: ErrorType.network,
          isRetryable: isRetryable,
        );
}

/// Validation errors
class ValidationError extends AppError {
  final Map<String, List<String>>? fieldErrors;
  
  ValidationError.now({
    required String message,
    String? details,
    this.fieldErrors,
  }) : super.now(
          message: message,
          details: details,
          type: ErrorType.validation,
          isRetryable: false,
        );
}

/// Business logic errors
class BusinessError extends AppError {
  BusinessError.now({
    required String message,
    String? details,
    bool isRetryable = false,
  }) : super.now(
          message: message,
          details: details,
          type: ErrorType.business,
          isRetryable: isRetryable,
        );
}

/// Platform/permission errors
class PlatformError extends AppError {
  PlatformError.now({
    required String message,
    String? details,
    bool isRetryable = false,
  }) : super.now(
          message: message,
          details: details,
          type: ErrorType.platform,
          isRetryable: isRetryable,
        );
}
library form_validators;

/// Common validation functions for forms
class Validators {
  /// Validates that a field is not empty
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates minimum length
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters long';
    }
    return null;
  }

  /// Validates maximum length
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value == null) return null;
    
    if (value.length > maxLength) {
      return '${fieldName ?? 'This field'} cannot exceed $maxLength characters';
    }
    return null;
  }

  /// Validates numeric input
  static String? numeric(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;
    
    final numeric = num.tryParse(value);
    if (numeric == null) {
      return '${fieldName ?? 'This field'} must be a valid number';
    }
    return null;
  }

  /// Validates positive integer
  static String? positiveInteger(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;
    
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return '${fieldName ?? 'This field'} must be a positive integer';
    }
    return null;
  }

  /// Validates range for numeric values
  static String? range(String? value, double min, double max, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;
    
    final number = num.tryParse(value);
    if (number == null) {
      return '${fieldName ?? 'This field'} must be a valid number';
    }
    
    if (number < min || number > max) {
      return '${fieldName ?? 'This field'} must be between $min and $max';
    }
    return null;
  }

  /// Validates password strength
  static String? password(String? value) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  /// Compose multiple validators
  static String? Function(String?) compose(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  /// Validates activity duration (fitness app specific)
  static String? activityDuration(String? value) {
    return compose([
      (value) => required(value, 'Duration'),
      (value) => positiveInteger(value, 'Duration'),
      (value) => range(value, 1, 480, 'Duration'), // Max 8 hours
    ])(value);
  }

  /// Validates step count (fitness app specific)
  static String? stepCount(String? value) {
    return compose([
      (value) => positiveInteger(value, 'Step count'),
      (value) => range(value, 1, 100000, 'Step count'), // Reasonable max steps per day
    ])(value);
  }

  /// Validates user weight (fitness app specific)
  static String? weight(String? value) {
    return compose([
      (value) => numeric(value, 'Weight'),
      (value) => range(value, 20, 1000, 'Weight'), // Reasonable weight range in kg
    ])(value);
  }

  /// Validates user height (fitness app specific)
  static String? height(String? value) {
    return compose([
      (value) => numeric(value, 'Height'),
      (value) => range(value, 50, 300, 'Height'), // Reasonable height range in cm
    ])(value);
  }
}

/// Form validation state provider
class FormValidationState {
  final Map<String, String?> _errors = {};
  final Map<String, dynamic> _values = {};

  /// Add field value
  void setValue(String fieldName, dynamic value) {
    _values[fieldName] = value;
  }

  /// Get field value
  T? getValue<T>(String fieldName) {
    return _values[fieldName] as T?;
  }

  /// Validate a field
  void validateField(String fieldName, String? Function(String?) validator) {
    final value = _values[fieldName]?.toString();
    final error = validator(value);
    
    if (error != null) {
      _errors[fieldName] = error;
    } else {
      _errors.remove(fieldName);
    }
  }

  /// Get field error
  String? getError(String fieldName) {
    return _errors[fieldName];
  }

  /// Check if form is valid
  bool get isValid => _errors.isEmpty;

  /// Get all errors
  Map<String, String> get errors => Map.unmodifiable(_errors.cast());

  /// Clear all validation
  void clear() {
    _errors.clear();
    _values.clear();
  }

  /// Clear specific field
  void clearField(String fieldName) {
    _errors.remove(fieldName);
    _values.remove(fieldName);
  }
}
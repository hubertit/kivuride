import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

/// Utility class for providing haptic feedback throughout the app
class HapticFeedbackManager {
  static bool _isEnabled = true;

  /// Enable or disable haptic feedback
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Check if haptic feedback is enabled
  static bool get isEnabled => _isEnabled;

  /// Light haptic feedback for subtle interactions
  static Future<void> light() async {
    if (!_isEnabled) return;
    
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Medium haptic feedback for standard interactions
  static Future<void> medium() async {
    if (!_isEnabled) return;
    
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Heavy haptic feedback for important interactions
  static Future<void> heavy() async {
    if (!_isEnabled) return;
    
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Selection haptic feedback for UI selections
  static Future<void> selection() async {
    if (!_isEnabled) return;
    
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Success haptic feedback for successful actions
  static Future<void> success() async {
    if (!_isEnabled) return;
    
    try {
      // Custom success pattern: light-medium-light
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 50));
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 50));
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Error haptic feedback for error states
  static Future<void> error() async {
    if (!_isEnabled) return;
    
    try {
      // Custom error pattern: heavy-heavy
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Warning haptic feedback for warning states
  static Future<void> warning() async {
    if (!_isEnabled) return;
    
    try {
      // Custom warning pattern: medium-medium
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Custom vibration pattern
  static Future<void> customPattern(List<int> pattern) async {
    if (!_isEnabled) return;
    
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(pattern: pattern);
      }
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Long press haptic feedback
  static Future<void> longPress() async {
    if (!_isEnabled) return;
    
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Button press haptic feedback
  static Future<void> buttonPress() async {
    if (!_isEnabled) return;
    
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Toggle haptic feedback
  static Future<void> toggle() async {
    if (!_isEnabled) return;
    
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Navigation haptic feedback
  static Future<void> navigation() async {
    if (!_isEnabled) return;
    
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Fallback to system haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  /// Form validation haptic feedback
  static Future<void> validation(bool isValid) async {
    if (!_isEnabled) return;
    
    if (isValid) {
      await light();
    } else {
      await error();
    }
  }

  /// Check if device supports haptic feedback
  static Future<bool> get hasHapticSupport async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      return hasVibrator == true;
    } catch (e) {
      return false;
    }
  }
}

/// Mixin for adding haptic feedback to widgets
mixin HapticFeedbackMixin on Widget {
  /// Add haptic feedback to button press
  Future<void> hapticButtonPress() async {
    await HapticFeedbackManager.buttonPress();
  }

  /// Add haptic feedback to selection
  Future<void> hapticSelection() async {
    await HapticFeedbackManager.selection();
  }

  /// Add haptic feedback to success
  Future<void> hapticSuccess() async {
    await HapticFeedbackManager.success();
  }

  /// Add haptic feedback to error
  Future<void> hapticError() async {
    await HapticFeedbackManager.error();
  }

  /// Add haptic feedback to warning
  Future<void> hapticWarning() async {
    await HapticFeedbackManager.warning();
  }

  /// Add haptic feedback to navigation
  Future<void> hapticNavigation() async {
    await HapticFeedbackManager.navigation();
  }
}

/// Enhanced button with haptic feedback
class HapticButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final HapticFeedbackType feedbackType;
  final ButtonStyle? style;

  const HapticButton({
    super.key,
    required this.child,
    this.onPressed,
    this.feedbackType = HapticFeedbackType.light,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null ? _handlePress : null,
      style: style,
      child: child,
    );
  }

  Future<void> _handlePress() async {
    await _provideFeedback();
    onPressed?.call();
  }

  Future<void> _provideFeedback() async {
    switch (feedbackType) {
      case HapticFeedbackType.light:
        await HapticFeedbackManager.light();
        break;
      case HapticFeedbackType.medium:
        await HapticFeedbackManager.medium();
        break;
      case HapticFeedbackType.heavy:
        await HapticFeedbackManager.heavy();
        break;
      case HapticFeedbackType.success:
        await HapticFeedbackManager.success();
        break;
      case HapticFeedbackType.error:
        await HapticFeedbackManager.error();
        break;
      case HapticFeedbackType.warning:
        await HapticFeedbackManager.warning();
        break;
      case HapticFeedbackType.navigation:
        await HapticFeedbackManager.navigation();
        break;
    }
  }
}

/// Haptic feedback types
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  success,
  error,
  warning,
  navigation,
}

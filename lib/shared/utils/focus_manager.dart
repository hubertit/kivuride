import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Utility class for managing focus and keyboard behavior
class FocusManager {
  /// Move focus to the next field in a form
  static void nextField(BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    if (nextFocus != null) {
      currentFocus.unfocus();
      nextFocus.requestFocus();
    } else {
      // If no next focus, hide keyboard
      currentFocus.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }

  /// Move focus to the previous field in a form
  static void previousField(BuildContext context, FocusNode currentFocus, FocusNode? previousFocus) {
    if (previousFocus != null) {
      currentFocus.unfocus();
      previousFocus.requestFocus();
    }
  }

  /// Hide keyboard and remove focus from all fields
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// Show keyboard for a specific field
  static void showKeyboard(FocusNode focusNode) {
    focusNode.requestFocus();
  }

  /// Handle form submission by hiding keyboard
  static void handleFormSubmission(BuildContext context) {
    hideKeyboard(context);
  }

  /// Create a focus node with automatic disposal
  static FocusNode createFocusNode() {
    return FocusNode();
  }

  /// Dispose a focus node safely
  static void disposeFocusNode(FocusNode? focusNode) {
    focusNode?.dispose();
  }
}

/// Mixin for managing multiple focus nodes in a form
mixin FormFocusMixin<T extends StatefulWidget> on State<T> {
  final Map<String, FocusNode> _focusNodes = {};

  /// Get or create a focus node with the given key
  FocusNode getFocusNode(String key) {
    if (!_focusNodes.containsKey(key)) {
      _focusNodes[key] = FocusNode();
    }
    return _focusNodes[key]!;
  }

  /// Move to next field in sequence
  void moveToNextField(String currentKey, String? nextKey) {
    final currentFocus = _focusNodes[currentKey];
    final nextFocus = nextKey != null ? _focusNodes[nextKey] : null;
    
    if (currentFocus != null) {
      FocusManager.nextField(context, currentFocus, nextFocus);
    }
  }

  /// Move to previous field in sequence
  void moveToPreviousField(String currentKey, String? previousKey) {
    final currentFocus = _focusNodes[currentKey];
    final previousFocus = previousKey != null ? _focusNodes[previousKey] : null;
    
    if (currentFocus != null) {
      FocusManager.previousField(context, currentFocus, previousFocus);
    }
  }

  /// Hide keyboard and clear all focus
  void hideKeyboard() {
    FocusManager.hideKeyboard(context);
  }

  @override
  void dispose() {
    // Dispose all focus nodes
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    _focusNodes.clear();
    super.dispose();
  }
}

/// Widget that automatically handles keyboard dismissal when tapping outside
class KeyboardDismissWrapper extends StatelessWidget {
  final Widget child;
  final bool dismissOnTap;

  const KeyboardDismissWrapper({
    super.key,
    required this.child,
    this.dismissOnTap = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!dismissOnTap) {
      return child;
    }

    return GestureDetector(
      onTap: () => FocusManager.hideKeyboard(context),
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

/// Enhanced form widget with better focus management
class EnhancedForm extends StatefulWidget {
  final Widget child;
  final GlobalKey<FormState>? formKey;
  final AutovalidateMode? autovalidateMode;
  final void Function()? onSubmit;
  final bool autoFocusFirstField;

  const EnhancedForm({
    super.key,
    required this.child,
    this.formKey,
    this.autovalidateMode,
    this.onSubmit,
    this.autoFocusFirstField = false,
  });

  @override
  State<EnhancedForm> createState() => _EnhancedFormState();
}

class _EnhancedFormState extends State<EnhancedForm> {
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    if (widget.autoFocusFirstField) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusFirstField();
      });
    }
  }

  void _focusFirstField() {
    if (_focusNodes.isNotEmpty) {
      _focusNodes.first.requestFocus();
    }
  }



  @override
  Widget build(BuildContext context) {
    return KeyboardDismissWrapper(
      child: Form(
        key: widget.formKey,
        autovalidateMode: widget.autovalidateMode,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}

/// Extension on FocusNode for easier focus management
extension FocusNodeExtension on FocusNode {
  /// Move focus to the next field
  void moveToNext(FocusNode? nextFocus) {
    if (nextFocus != null) {
      unfocus();
      nextFocus.requestFocus();
    } else {
      unfocus();
    }
  }

  /// Move focus to the previous field
  void moveToPrevious(FocusNode? previousFocus) {
    if (previousFocus != null) {
      unfocus();
      previousFocus.requestFocus();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class FocusHandler extends ChangeNotifier with WidgetsBindingObserver {
  bool _hasFocus = true;
  bool get hasFocus => _hasFocus;

  FocusHandler() {
    WidgetsBinding.instance.addObserver(this);
    _setupWebFocusListeners();
  }

  void _setupWebFocusListeners() {
    // Web focus/blur events
    html.window.onFocus.listen((_) {
      _updateFocus(true);
    });

    html.window.onBlur.listen((_) {
      _updateFocus(false);
    });

    // Visibility change events
    html.document.onVisibilityChange.listen((_) {
      final isVisible = !html.document.hidden!;
      _updateFocus(isVisible);
    });

    // Page focus/blur events
    html.window.addEventListener('focus', (_) {
      _updateFocus(true);
    });

    html.window.addEventListener('blur', (_) {
      _updateFocus(false);
    });
  }

  void _updateFocus(bool hasFocus) {
    if (_hasFocus != hasFocus) {
      _hasFocus = hasFocus;
      notifyListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _updateFocus(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _updateFocus(false);
        break;
      case AppLifecycleState.detached:
        _updateFocus(false);
        break;
      case AppLifecycleState.hidden:
        _updateFocus(false);
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
} 
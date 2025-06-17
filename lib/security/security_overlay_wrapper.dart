import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'focus_handler.dart';
import 'security_overlay.dart';

class SecurityOverlayWrapper extends StatefulWidget {
  final Widget child;
  final bool enableSecurity;

  const SecurityOverlayWrapper({
    super.key,
    required this.child,
    this.enableSecurity = true,
  });

  @override
  State<SecurityOverlayWrapper> createState() => _SecurityOverlayWrapperState();
}

class _SecurityOverlayWrapperState extends State<SecurityOverlayWrapper> {
  late FocusHandler _focusHandler;

  @override
  void initState() {
    super.initState();
    _focusHandler = FocusHandler();
  }

  @override
  void dispose() {
    _focusHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableSecurity) {
      return widget.child;
    }

    return ChangeNotifierProvider<FocusHandler>.value(
      value: _focusHandler,
      child: Consumer<FocusHandler>(
        builder: (context, focusHandler, child) {
          return Stack(
            children: [
              // Main content
              widget.child,
              
              // Security overlay
              SecurityOverlay(
                isVisible: !focusHandler.hasFocus,
                onTap: () {
                  // Focus will be restored automatically when user interacts
                  // This is just for immediate feedback
                },
              ),
            ],
          );
        },
      ),
    );
  }
} 
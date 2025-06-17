import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomCursor extends StatefulWidget {
  final Widget child;
  
  const CustomCursor({super.key, required this.child});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor> {
  double _x = 0;
  double _y = 0;
  bool _isHovering = false;

  void _updatePosition(PointerEvent details) {
    setState(() {
      _x = details.position.dx;
      _y = details.position.dy;
    });
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      _isHovering = true;
      _x = event.position.dx;
      _y = event.position.dy;
    });
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _isHovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _updatePosition,
      child: Stack(
        children: [
          widget.child,
          
          // Sade cursor
          if (_isHovering)
            Positioned(
              left: _x - 8,
              top: _y - 8,
              child: IgnorePointer(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2196F3),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 
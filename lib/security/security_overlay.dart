import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';
import 'dart:ui';

class SecurityOverlay extends StatefulWidget {
  final bool isVisible;
  final VoidCallback? onTap;

  const SecurityOverlay({
    super.key,
    required this.isVisible,
    this.onTap,
  });

  @override
  State<SecurityOverlay> createState() => _SecurityOverlayState();
}

class _SecurityOverlayState extends State<SecurityOverlay>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _fadeController.forward();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SecurityOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _fadeController.forward();
        _pulseController.repeat(reverse: true);
      } else {
        _fadeController.reverse();
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: _buildOverlayContent(l10n, isMobile),
        );
      },
    ),);
  }

  Widget _buildOverlayContent(AppLocalizations l10n, bool isMobile) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: widget.onTap,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.black.withValues(alpha: 0.6),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? 320 : 400,
                ),
                padding: EdgeInsets.all(isMobile ? 24 : 32),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Lock Icon
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: isMobile ? 80 : 96,
                            height: isMobile ? 80 : 96,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: AppTheme.primaryColor.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.lock_outline,
                              size: isMobile ? 40 : 48,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: isMobile ? 24 : 32),
                    
                    // Security Message
                    Text(
                      l10n.securityOverlayTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                    
                    SizedBox(height: isMobile ? 16 : 20),
                    
                    // Subtle hint
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.securityOverlayHint,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
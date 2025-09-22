import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';
import '../constants/app_constants.dart';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:html' as html;

class GitHubSection extends StatefulWidget {
  const GitHubSection({super.key});

  @override
  State<GitHubSection> createState() => _GitHubSectionState();
}

class _GitHubSectionState extends State<GitHubSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: ResponsiveHelper.getScreenPadding(context).copyWith(
                    top: 80,
                    bottom: 80,
                  ),
                  color: AppTheme.getSurfaceColor(appProvider.isDarkMode),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ResponsiveHelper.getMaxContentWidth(context),
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.githubTitle,
                            style: AppTheme.getHeadingMedium(appProvider.isDarkMode),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.githubDescription,
                            style: AppTheme.getBodyLarge(appProvider.isDarkMode),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 60),
                          ResponsiveHelper.isMobile(context)
                              ? _buildMobileLayout(context, appProvider)
                              : _buildDesktopLayout(context, appProvider),
                          const SizedBox(height: 40),
                          // CV İndirme Butonu
                          _buildDownloadCVButton(context, appProvider),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppProvider appProvider) {
    return Column(
      children: [
        _buildProfileCard(context, appProvider),
        const SizedBox(height: 32),
        _buildStatsCard(context, appProvider),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AppProvider appProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildProfileCard(context, appProvider),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 1,
          child: _buildStatsCard(context, appProvider),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, AppProvider appProvider) {
    final l10n = AppLocalizations.of(context)!;
    
    return _AnimatedProfileCard(
      isDarkMode: appProvider.isDarkMode,
      onGitHubPressed: _launchGitHub,
      l10n: l10n,
    );
  }

  Widget _buildStatsCard(BuildContext context, AppProvider appProvider) {
    final l10n = AppLocalizations.of(context)!;
    
    return _AnimatedStatsCard(
      isDarkMode: appProvider.isDarkMode,
      l10n: l10n,
    );
  }



  Widget _buildDownloadCVButton(BuildContext context, AppProvider appProvider) {
    final l10n = AppLocalizations.of(context)!;
    
    return _AnimatedCVButton(
      isDarkMode: appProvider.isDarkMode,
      l10n: l10n,
      onPressed: _downloadCV,
    );
  }

  void _launchGitHub() async {
    final url = Uri.parse(AppConstants.githubUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _downloadCV() async {
    // CV indirme işlemi - gerçek uygulamada bir PDF dosyası linkini kullanın
    const cvUrl = 'https://example.com/ali-hasanov-cv.pdf'; // Gerçek CV linkini ekleyin
    final url = Uri.parse(cvUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Hata durumunda kullanıcıya bilgi verin
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CV indirilemedi. Lütfen daha sonra tekrar deneyin.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}

// Animated Profile Card with Hover Effects
class _AnimatedProfileCard extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onGitHubPressed;
  final AppLocalizations l10n;

  const _AnimatedProfileCard({
    required this.isDarkMode,
    required this.onGitHubPressed,
    required this.l10n,
  });

  @override
  State<_AnimatedProfileCard> createState() => _AnimatedProfileCardState();
}

class _AnimatedProfileCardState extends State<_AnimatedProfileCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _elevationAnimation = Tween<double>(
      begin: 8.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.015,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                transform: Matrix4.identity()
                  ..translate(0.0, _isHovered ? -8.0 : 0.0, 0.0),
                child: Card(
                  color: AppTheme.getCardColor(widget.isDarkMode),
                  elevation: _elevationAnimation.value,
                  shadowColor: AppTheme.primaryColor.withOpacity(_isHovered ? 0.4 : 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: _isHovered 
                          ? AppTheme.primaryColor.withOpacity(0.6)
                          : AppTheme.primaryColor.withOpacity(0.2),
                      width: _isHovered ? 2 : 1,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: _isHovered 
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryColor.withOpacity(0.08),
                                AppTheme.primaryColor.withOpacity(0.03),
                              ],
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        // Avatar with animation
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 400),
                          tween: Tween<double>(
                            begin: 0.0,
                            end: _isHovered ? 1.0 : 0.0,
                          ),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: 1.0 + (value * 0.1),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCubic,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.primaryColor.withOpacity(_isHovered ? 0.6 : 0.3),
                                    width: _isHovered ? 4 : 2,
                                  ),
                                  boxShadow: _isHovered ? [
                                    BoxShadow(
                                      color: AppTheme.primaryColor.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 3,
                                    ),
                                  ] : null,
                                ),
                                child: CircleAvatar(
                                  radius: _isHovered ? 55 : 50,
                                  backgroundImage: AssetImage(AppConstants.defaultGithubImage),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Name
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          style: AppTheme.getHeadingSmall(widget.isDarkMode).copyWith(
                            color: _isHovered 
                                ? AppTheme.primaryColor
                                : AppTheme.getTextPrimaryColor(widget.isDarkMode),
                            fontSize: _isHovered ? 22 : 20,
                            fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                          ),
                          child: Text(
                            AppConstants.developerName,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Username
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          style: AppTheme.getBodyMedium(widget.isDarkMode).copyWith(
                            color: AppTheme.primaryColor,
                            fontSize: _isHovered ? 16 : 15,
                            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                          ),
                          child: Text(
                            "@${AppConstants.githubUsername}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Description
                       /* Text(
                          "Senior Flutter Developer with extensive experience in building high-quality cross-platform applications.",
                          style: AppTheme.getBodySmall(widget.isDarkMode).copyWith(
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                     */
                        const SizedBox(height: 24),
                        
                        // GitHub Button
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          child: ElevatedButton.icon(
                            onPressed: widget.onGitHubPressed,
                            icon: Icon(
                              Icons.open_in_new,
                              size: _isHovered ? 18 : 16,
                            ),
                            label: Text(
                              widget.l10n.viewOnGithub,
                              style: TextStyle(
                                fontSize: _isHovered ? 14 : 13,
                                fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isHovered 
                                  ? AppTheme.primaryColor
                                  : AppTheme.primaryColor.withOpacity(0.9),
                              foregroundColor: Colors.white,
                              elevation: _isHovered ? 8 : 4,
                              shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Animated Stats Card with Hover Effects
class _AnimatedStatsCard extends StatefulWidget {
  final bool isDarkMode;
  final AppLocalizations l10n;

  const _AnimatedStatsCard({
    required this.isDarkMode,
    required this.l10n,
  });

  @override
  State<_AnimatedStatsCard> createState() => _AnimatedStatsCardState();
}

class _AnimatedStatsCardState extends State<_AnimatedStatsCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _elevationAnimation = Tween<double>(
      begin: 8.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..translate(0.0, _isHovered ? -8.0 : 0.0, 0.0),
              child: Card(
                color: AppTheme.getCardColor(widget.isDarkMode),
                elevation: _elevationAnimation.value,
                shadowColor: AppTheme.primaryColor.withOpacity(_isHovered ? 0.4 : 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: _isHovered 
                        ? AppTheme.primaryColor.withOpacity(0.6)
                        : AppTheme.primaryColor.withOpacity(0.2),
                    width: _isHovered ? 2 : 1,
                  ),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: _isHovered 
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.08),
                              AppTheme.primaryColor.withOpacity(0.03),
                            ],
                          )
                        : null,
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        style: AppTheme.getHeadingSmall(widget.isDarkMode).copyWith(
                          color: _isHovered 
                              ? AppTheme.primaryColor
                              : AppTheme.getTextPrimaryColor(widget.isDarkMode),
                          fontSize: _isHovered ? 22 : 20,
                        ),
                        child: Text(widget.l10n.githubStatistics),
                      ),
                      const SizedBox(height: 24),
                      
                      // Stats
                      _buildAnimatedStatRow(widget.l10n.publicRepos, "15+", 0, widget.isDarkMode),
                      const SizedBox(height: 16),
                      _buildAnimatedStatRow(widget.l10n.followers, "3", 200, widget.isDarkMode),
                      const SizedBox(height: 16),
                      _buildAnimatedStatRow(widget.l10n.following, "2", 400, widget.isDarkMode),
                      const SizedBox(height: 24),
                      
                      // Languages Title
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        style: AppTheme.getLabelLarge(widget.isDarkMode).copyWith(
                          color: _isHovered 
                              ? AppTheme.primaryColor
                              : AppTheme.getTextPrimaryColor(widget.isDarkMode),
                          fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                        ),
                        child: Text(widget.l10n.topLanguages),
                      ),
                      const SizedBox(height: 12),
                      
                      // Language chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildAnimatedLanguageChip("Dart", 600, widget.isDarkMode),
                          _buildAnimatedLanguageChip("Flutter", 700, widget.isDarkMode),
                          _buildAnimatedLanguageChip("PyQt5", 800, widget.isDarkMode),
                          _buildAnimatedLanguageChip("Python", 900, widget.isDarkMode),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedStatRow(String label, String value, int delay, bool isDarkMode) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + delay),
      tween: Tween<double>(
        begin: 0.0,
        end: _isHovered ? 1.0 : 0.0,
      ),
      builder: (context, animationValue, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(animationValue * 12.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTheme.getBodyMedium(isDarkMode).copyWith(
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: _isHovered ? 12 : 8,
                  vertical: _isHovered ? 6 : 4,
                ),
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? AppTheme.primaryColor.withOpacity(0.15)
                      : AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(_isHovered ? 0.4 : 0.3),
                  ),
                ),
                child: Text(
                  value,
                  style: AppTheme.getBodyMedium(isDarkMode).copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: _isHovered ? 15 : 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLanguageChip(String language, int delay, bool isDarkMode) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + delay),
      tween: Tween<double>(
        begin: 0.0,
        end: _isHovered ? 1.0 : 0.0,
      ),
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 1.0 + (animationValue * 0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: _isHovered ? 14 : 10,
              vertical: _isHovered ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: _isHovered 
                  ? AppTheme.primaryColor.withOpacity(0.15)
                  : AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(_isHovered ? 0.4 : 0.3),
              ),
              boxShadow: _isHovered ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ] : null,
            ),
            child: Text(
              language,
              style: AppTheme.getBodySmall(isDarkMode).copyWith(
                color: AppTheme.primaryColor,
                fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                fontSize: _isHovered ? 13 : 12,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Animated CV Button with Hover Effects
class _AnimatedCVButton extends StatefulWidget {
  final bool isDarkMode;
  final AppLocalizations l10n;
  final VoidCallback onPressed;

  const _AnimatedCVButton({
    required this.isDarkMode,
    required this.l10n,
    required this.onPressed,
  });

  @override
  State<_AnimatedCVButton> createState() => _AnimatedCVButtonState();
}

class _AnimatedCVButtonState extends State<_AnimatedCVButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..translate(0.0, _isHovered ? -6.0 : 0.0, 0.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isHovered ? [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.7),
                  ] : [
                    AppTheme.primaryColor.withOpacity(0.9),
                    AppTheme.primaryColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(_isHovered ? 0.5 : 0.3),
                    blurRadius: _isHovered ? 25 : 20,
                    offset: Offset(0, _isHovered ? 12 : 10),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: ()async{
                  final bytes = await rootBundle.load('assets/cv/cv_of_ali_hasanov.pdf');
                  final blob = html.Blob([bytes.buffer.asUint8List()]);
                  final url = html.Url.createObjectUrlFromBlob(blob);
                  final anchor = html.AnchorElement(href: url)
                    ..setAttribute("download", "cv_of_ali_hasanov.pdf")
                    ..click();
                  html.Url.revokeObjectUrl(url);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                      AppLocalizations.of(context).buttonDownloading,
                      style: TextStyle(color: AppTheme.primaryColor)
                    ) ),
                  );
                },
                icon: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween<double>(
                    begin: 0.0,
                    end: _isHovered ? 1.0 : 0.0,
                  ),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * 0.5,
                      child: Icon(
                        Icons.download_rounded,
                        color: Colors.white,
                        size: _isHovered ? 22 : 20,
                      ),
                    );
                  },
                ),
                label: Text(
                  widget.l10n.downloadCV,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: _isHovered ? FontWeight.w800 : FontWeight.bold,
                    fontSize: _isHovered ? 17 : 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: _isHovered ? 36 : 32,
                    vertical: _isHovered ? 18 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 
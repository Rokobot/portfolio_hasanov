import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/project.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';

class ProjectDetailPage extends StatefulWidget {
  final Project project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.getBackgroundColor(appProvider.isDarkMode),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: FutureBuilder<Project>(
                future: _loadProjectDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState(appProvider.isDarkMode);
                  }
                  
                  final project = snapshot.data ?? widget.project;
                  
                  return CustomScrollView(
                    slivers: [
                      _buildAppBar(context, appProvider.isDarkMode, l10n),
                      SliverToBoxAdapter(
                        child: ResponsiveHelper.isMobile(context)
                            ? _buildMobileLayout(context, appProvider.isDarkMode, project, l10n)
                            : _buildDesktopLayout(context, appProvider.isDarkMode, project, l10n),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Project> _loadProjectDetails() async {
    // Simulate async loading
    await Future.delayed(const Duration(milliseconds: 500));
    return widget.project;
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Proje yükleniyor...',
            style: AppTheme.getBodyMedium(isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDarkMode, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: true,
      backgroundColor: AppTheme.getBackgroundColor(isDarkMode).withOpacity(0.9),
      elevation: 0,
      leading: _AnimatedBackButton(isDarkMode: isDarkMode),
      title: Text(
        widget.project.title,
        style: AppTheme.getHeadingSmall(isDarkMode),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.getBackgroundColor(isDarkMode),
                AppTheme.getBackgroundColor(isDarkMode).withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isDarkMode, Project project, AppLocalizations l10n) {
    return Container(
      padding: ResponsiveHelper.getScreenPadding(context).copyWith(
        top: 40,
        bottom: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getMaxContentWidth(context),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Image
              Expanded(
                flex: 5,
                child: _buildProjectImage(isDarkMode, project),
              ),
              const SizedBox(width: 60),
              // Right Column - Content
              Expanded(
                flex: 7,
                child: _buildProjectContent(context, isDarkMode, project, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isDarkMode, Project project, AppLocalizations l10n) {
    return Container(
      padding: ResponsiveHelper.getScreenPadding(context).copyWith(
        top: 20,
        bottom: 60,
      ),
      child: Column(
        children: [
          _buildProjectImage(isDarkMode, project),
          const SizedBox(height: 32),
          _buildProjectContent(context, isDarkMode, project, l10n),
        ],
      ),
    );
  }

  Widget _buildProjectImage(bool isDarkMode, Project project) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween<double>(begin: 0.8, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: ResponsiveHelper.isMobile(context) ? 16 / 10 : 4 / 3,
                child: Image.asset(
                  project.image.isNotEmpty 
                      ? project.image 
                      : 'assets/images/default_project.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.1),
                            AppTheme.primaryColor.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: 80,
                        color: AppTheme.primaryColor.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectContent(BuildContext context, bool isDarkMode, Project project, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Text(
                project.title,
                style: AppTheme.getHeadingLarge(isDarkMode).copyWith(
                  fontSize: ResponsiveHelper.isMobile(context) ? 28 : 36,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        
        // Description
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Text(
                project.description,
                style: AppTheme.getBodyLarge(isDarkMode).copyWith(
                  height: 1.6,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        
        // Tech Stack
        _buildTechStack(isDarkMode, project),
        const SizedBox(height: 32),
        
        // Key Features
        _buildKeyFeatures(isDarkMode, project, l10n),
        const SizedBox(height: 40),
        
        // Action Buttons
        _buildActionButtons(isDarkMode, project, l10n),
      ],
    );
  }

  Widget _buildTechStack(bool isDarkMode, Project project) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Teknolojiler',
                style: AppTheme.getHeadingSmall(isDarkMode).copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: project.technologies.map((tech) {
                  return _AnimatedTechChip(
                    technology: tech,
                    isDarkMode: isDarkMode,
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKeyFeatures(bool isDarkMode, Project project, AppLocalizations l10n) {
    final features = [
      '🔧 Flutter ile geliştirildi',
      '🚀 Modern UI/UX tasarım',
      '📱 Responsive tasarım',
      '🔐 Güvenli kod yapısı',
      '⚡ Yüksek performans',
      '🎨 Çoklu tema desteği',
    ];

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Öne Çıkan Özellikler',
                style: AppTheme.getHeadingSmall(isDarkMode).copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              ...features.asMap().entries.map((entry) {
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 600 + (entry.key * 100)),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, slideOpacity, child) {
                    return Transform.translate(
                      offset: Offset((1 - slideOpacity) * 30, 0),
                      child: Opacity(
                        opacity: slideOpacity,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Text(
                                entry.value.split(' ')[0],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.value.substring(entry.value.indexOf(' ') + 1),
                                  style: AppTheme.getBodyMedium(isDarkMode),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(bool isDarkMode, Project project, AppLocalizations l10n) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1600),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: ResponsiveHelper.isMobile(context)
              ? Column(
                  children: [
                    if (project.hasLiveUrl) ...[
                      _AnimatedActionButton(
                        label: 'Canlı Demo',
                        icon: Icons.launch,
                        isPrimary: true,
                        isDarkMode: isDarkMode,
                        onPressed: () => _launchUrl(project.liveUrl),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (project.hasGithubUrl) ...[
                      _AnimatedActionButton(
                        label: 'GitHub\'da Görüntüle',
                        icon: Icons.code,
                        isPrimary: false,
                        isDarkMode: isDarkMode,
                        onPressed: () => _launchUrl(project.githubUrl),
                      ),
                      const SizedBox(height: 12),
                    ],
                    _AnimatedActionButton(
                      label: 'Geri Dön',
                      icon: Icons.arrow_back,
                      isPrimary: false,
                      isDarkMode: isDarkMode,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                )
              : Row(
                  children: [
                    if (project.hasLiveUrl) ...[
                      Expanded(
                        child: _AnimatedActionButton(
                          label: 'Canlı Demo',
                          icon: Icons.launch,
                          isPrimary: true,
                          isDarkMode: isDarkMode,
                          onPressed: () => _launchUrl(project.liveUrl),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (project.hasGithubUrl) ...[
                      Expanded(
                        child: _AnimatedActionButton(
                          label: 'GitHub',
                          icon: Icons.code,
                          isPrimary: false,
                          isDarkMode: isDarkMode,
                          onPressed: () => _launchUrl(project.githubUrl),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: _AnimatedActionButton(
                        label: 'Geri Dön',
                        icon: Icons.arrow_back,
                        isPrimary: false,
                        isDarkMode: isDarkMode,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// Animated Back Button
class _AnimatedBackButton extends StatefulWidget {
  final bool isDarkMode;

  const _AnimatedBackButton({required this.isDarkMode});

  @override
  State<_AnimatedBackButton> createState() => _AnimatedBackButtonState();
}

class _AnimatedBackButtonState extends State<_AnimatedBackButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isHovered 
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: _isHovered 
                ? AppTheme.primaryColor
                : AppTheme.getTextPrimaryColor(widget.isDarkMode),
          ),
        ),
      ),
    );
  }
}

// Animated Tech Chip
class _AnimatedTechChip extends StatefulWidget {
  final String technology;
  final bool isDarkMode;

  const _AnimatedTechChip({
    required this.technology,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedTechChip> createState() => _AnimatedTechChipState();
}

class _AnimatedTechChipState extends State<_AnimatedTechChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: _isHovered ? 16 : 12,
          vertical: _isHovered ? 10 : 8,
        ),
        decoration: BoxDecoration(
          color: _isHovered 
              ? AppTheme.primaryColor.withOpacity(0.15)
              : AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
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
          widget.technology,
          style: AppTheme.getBodySmall(widget.isDarkMode).copyWith(
            color: AppTheme.primaryColor,
            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Animated Action Button
class _AnimatedActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isDarkMode;
  final VoidCallback onPressed;

  const _AnimatedActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.isDarkMode,
    required this.onPressed,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -2.0 : 0.0, 0.0),
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(
            widget.icon,
            size: _isHovered ? 20 : 18,
          ),
          label: Text(
            widget.label,
            style: TextStyle(
              fontSize: _isHovered ? 15 : 14,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isPrimary
                ? (_isHovered ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.9))
                : (_isHovered 
                    ? AppTheme.getCardColor(widget.isDarkMode)
                    : AppTheme.getSurfaceColor(widget.isDarkMode)),
            foregroundColor: widget.isPrimary
                ? Colors.white
                : AppTheme.getTextPrimaryColor(widget.isDarkMode),
            elevation: _isHovered ? 8 : 4,
            shadowColor: widget.isPrimary 
                ? AppTheme.primaryColor.withOpacity(0.3)
                : AppTheme.getTextPrimaryColor(widget.isDarkMode).withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: widget.isPrimary 
                  ? BorderSide.none
                  : BorderSide(
                      color: AppTheme.primaryColor.withOpacity(_isHovered ? 0.4 : 0.2),
                    ),
            ),
          ),
        ),
      ),
    );
  }
} 
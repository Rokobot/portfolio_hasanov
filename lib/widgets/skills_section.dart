import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Container(
          padding: ResponsiveHelper.getScreenPadding(context).copyWith(
            top: 80,
            bottom: 80,
          ),
          color: AppTheme.getBackgroundColor(appProvider.isDarkMode),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxContentWidth(context),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.skillsTitle,
                    style: AppTheme.getHeadingMedium(appProvider.isDarkMode),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.skillsDescription,
                    style: AppTheme.getBodyLarge(appProvider.isDarkMode),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: ResponsiveHelper.getCrossAxisCount(
                      context,
                      mobile: 2,
                      tablet: 3,
                      desktop: 4,
                    ),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      _buildSkillCard("Flutter", Icons.flutter_dash, appProvider.isDarkMode),
                      _buildSkillCard("Dart", Icons.code, appProvider.isDarkMode),
                      _buildSkillCard("Cloud Backend", Icons.cloud, appProvider.isDarkMode),
                      _buildSkillCard("REST API", Icons.api, appProvider.isDarkMode),
                      _buildSkillCard("Payment Integration", Icons.payment, appProvider.isDarkMode),
                      _buildSkillCard("State Managment", Icons.settings, appProvider.isDarkMode),
                      _buildSkillCard("Version Controll", Icons.source, appProvider.isDarkMode),
                      _buildSkillCard("Local Storage", Icons.storage, appProvider.isDarkMode),
                      _buildSkillCard("Architecture", Icons.cloud_queue, appProvider.isDarkMode),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillCard(String skill, IconData icon, bool isDarkMode) {
    return _AnimatedSkillCard(
      skill: skill,
      icon: icon,
      isDarkMode: isDarkMode,
    );
  }
}

class _AnimatedSkillCard extends StatefulWidget {
  final String skill;
  final IconData icon;
  final bool isDarkMode;

  const _AnimatedSkillCard({
    required this.skill,
    required this.icon,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedSkillCard> createState() => _AnimatedSkillCardState();
}

class _AnimatedSkillCardState extends State<_AnimatedSkillCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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
      begin: 6.0,
      end: 16.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.2,
      end: 0.4,
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
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..translate(0.0, _isHovered ? -8.0 : 0.0, 0.0),
              child: Card(
                color: AppTheme.getCardColor(widget.isDarkMode),
                elevation: _elevationAnimation.value,
                shadowColor: AppTheme.primaryColor.withOpacity(_glowAnimation.value),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: _isHovered 
                        ? AppTheme.primaryColor.withOpacity(0.5)
                        : AppTheme.primaryColor.withOpacity(0.1),
                    width: _isHovered ? 2 : 1,
                  ),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: _isHovered 
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.05),
                              AppTheme.primaryColor.withOpacity(0.02),
                            ],
                          )
                        : null,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween<double>(
                          begin: 0.0,
                          end: _isHovered ? 1.0 : 0.0,
                        ),
                        builder: (context, rotationValue, child) {
                          return Transform.rotate(
                            angle: rotationValue * 0.1, // Hafif dönüş efekti
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              width: _isHovered ? 56 : 48,
                              height: _isHovered ? 56 : 48,
                              decoration: BoxDecoration(
                                color: _isHovered 
                                    ? AppTheme.primaryColor.withOpacity(0.15)
                                    : AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _isHovered 
                                      ? AppTheme.primaryColor.withOpacity(0.4)
                                      : AppTheme.primaryColor.withOpacity(0.3),
                                  width: _isHovered ? 2.5 : 2,
                                ),
                                boxShadow: _isHovered ? [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.3),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ] : null,
                              ),
                              child: Icon(
                                widget.icon,
                                color: AppTheme.primaryColor,
                                size: _isHovered ? 28 : 24,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        style: AppTheme.getLabelLarge(widget.isDarkMode).copyWith(
                          color: _isHovered 
                              ? AppTheme.primaryColor
                              : AppTheme.getTextPrimaryColor(widget.isDarkMode),
                          fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                          fontSize: _isHovered ? 16 : 15,
                        ),
                        child: Text(
                          widget.skill,
                          textAlign: TextAlign.center,
                        ),
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
} 
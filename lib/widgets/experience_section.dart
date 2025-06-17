import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

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
                    l10n.experienceTitle,
                    style: AppTheme.getHeadingMedium(appProvider.isDarkMode),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.experienceDescription,
                    style: AppTheme.getBodyLarge(appProvider.isDarkMode),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) => _AnimatedExperienceCard(
                      index: index,
                      isDarkMode: appProvider.isDarkMode,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedExperienceCard extends StatefulWidget {
  final int index;
  final bool isDarkMode;

  const _AnimatedExperienceCard({
    required this.index,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedExperienceCard> createState() => _AnimatedExperienceCardState();
}

class _AnimatedExperienceCardState extends State<_AnimatedExperienceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _elevationAnimation = Tween<double>(
      begin: 6.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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
    final experiences = [
      {
        'title': 'Senior Flutter Developer',
        'company': 'Tech Innovation Co.',
        'period': '2022 - Present',
        'description': 'Leading mobile app development team, architecting scalable Flutter applications, and mentoring junior developers.',
        'achievements': [
          'Led development of 5+ mobile applications',
          'Implemented CI/CD pipelines reducing deployment time by 40%',
          'Mentored 3 junior developers'
        ],
        'icon': Icons.code,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'Flutter Developer',
        'company': 'Digital Solutions Ltd.',
        'period': '2020 - 2022',
        'description': 'Developed cross-platform mobile applications using Flutter and integrated various APIs and services.',
        'achievements': [
          'Built 10+ mobile applications',
          'Integrated payment gateways and analytics',
          'Improved app performance by 30%'
        ],
        'icon': Icons.mobile_friendly,
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'Mobile App Developer',
        'company': 'StartUp Ventures',
        'period': '2018 - 2020',
        'description': 'Started career in mobile development, worked on native Android and iOS before transitioning to Flutter.',
        'achievements': [
          'Developed 5+ native mobile apps',
          'Learned Flutter and Dart',
          'Contributed to open source projects'
        ],
        'icon': Icons.phone_android,
        'color': const Color(0xFFFF9800),
      },
    ];

    final experience = experiences[widget.index];

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
              margin: const EdgeInsets.only(bottom: 32),
              transform: Matrix4.identity()
                ..translate(_slideAnimation.value * 8.0, _isHovered ? -8.0 : 0.0, 0.0),
              child: Card(
                color: AppTheme.getCardColor(widget.isDarkMode),
                elevation: _elevationAnimation.value,
                shadowColor: (experience['color'] as Color).withOpacity(_isHovered ? 0.4 : 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: _isHovered 
                        ? (experience['color'] as Color).withOpacity(0.6)
                        : (experience['color'] as Color).withOpacity(0.2),
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
                              (experience['color'] as Color).withOpacity(0.08),
                              (experience['color'] as Color).withOpacity(0.03),
                            ],
                          )
                        : null,
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline dot with icon
                      Column(
                        children: [
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 400),
                            tween: Tween<double>(
                              begin: 0.0,
                              end: _isHovered ? 1.0 : 0.0,
                            ),
                            builder: (context, value, child) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCubic,
                                width: _isHovered ? 60 : 50,
                                height: _isHovered ? 60 : 50,
                                decoration: BoxDecoration(
                                  color: _isHovered 
                                      ? (experience['color'] as Color).withOpacity(0.15)
                                      : (experience['color'] as Color).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: experience['color'] as Color,
                                    width: _isHovered ? 3 : 2,
                                  ),
                                  boxShadow: _isHovered ? [
                                    BoxShadow(
                                      color: (experience['color'] as Color).withOpacity(0.3),
                                      blurRadius: 16,
                                      spreadRadius: 2,
                                    ),
                                  ] : null,
                                ),
                                child: Transform.rotate(
                                  angle: value * 0.1,
                                  child: Icon(
                                    experience['icon'] as IconData,
                                    color: experience['color'] as Color,
                                    size: _isHovered ? 28 : 24,
                                  ),
                                ),
                              );
                            },
                          ),
                          // Timeline line (except for last item)
                          if (widget.index < 2)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              margin: const EdgeInsets.only(top: 8),
                              width: _isHovered ? 3 : 2,
                              height: 60,
                              decoration: BoxDecoration(
                                color: (experience['color'] as Color).withOpacity(_isHovered ? 0.4 : 0.2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Job Title
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              style: AppTheme.getHeadingSmall(widget.isDarkMode).copyWith(
                                color: _isHovered 
                                    ? experience['color'] as Color
                                    : AppTheme.getTextPrimaryColor(widget.isDarkMode),
                                fontSize: _isHovered ? 22 : 20,
                                fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                              ),
                              child: Text(
                                experience['title'] as String,
                              ),
                            ),
                            const SizedBox(height: 6),
                            
                            // Company
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              style: AppTheme.getBodyMedium(widget.isDarkMode).copyWith(
                                color: experience['color'] as Color,
                                fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                                fontSize: _isHovered ? 17 : 16,
                              ),
                              child: Text(
                                experience['company'] as String,
                              ),
                            ),
                            const SizedBox(height: 4),
                            
                            // Period
                            Text(
                              experience['period'] as String,
                              style: AppTheme.getBodySmall(widget.isDarkMode).copyWith(
                                fontStyle: FontStyle.italic,
                                color: AppTheme.getTextSecondaryColor(widget.isDarkMode),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Description
                            Text(
                              experience['description'] as String,
                              style: AppTheme.getBodyMedium(widget.isDarkMode).copyWith(
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Achievements
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              style: AppTheme.getLabelLarge(widget.isDarkMode).copyWith(
                                fontWeight: FontWeight.w600,
                                color: _isHovered 
                                    ? experience['color'] as Color
                                    : AppTheme.getTextPrimaryColor(widget.isDarkMode),
                              ),
                              child: Text('Key Achievements:'),
                            ),
                            const SizedBox(height: 12),
                            
                            ...((experience['achievements'] as List<String>).asMap().entries.map((entry) {
                              final index = entry.key;
                              final achievement = entry.value;
                              
                              return TweenAnimationBuilder<double>(
                                duration: Duration(milliseconds: 400 + (index * 100)),
                                tween: Tween<double>(
                                  begin: 0.0,
                                  end: _isHovered ? 1.0 : 0.0,
                                ),
                                builder: (context, value, child) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOutCubic,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    transform: Matrix4.identity()
                                      ..translate(value * 12.0, 0.0, 0.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.easeOutCubic,
                                          margin: const EdgeInsets.only(top: 6),
                                          width: _isHovered ? 6 : 4,
                                          height: _isHovered ? 6 : 4,
                                          decoration: BoxDecoration(
                                            color: experience['color'] as Color,
                                            shape: BoxShape.circle,
                                            boxShadow: _isHovered ? [
                                              BoxShadow(
                                                color: (experience['color'] as Color).withOpacity(0.4),
                                                blurRadius: 6,
                                                spreadRadius: 1,
                                              ),
                                            ] : null,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            achievement,
                                            style: AppTheme.getBodySmall(widget.isDarkMode).copyWith(
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            })).toList(),
                          ],
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
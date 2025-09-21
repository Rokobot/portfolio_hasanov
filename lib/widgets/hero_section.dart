import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';
import '../constants/app_constants.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Container(
          height: ResponsiveHelper.getScreenHeight(context),
          decoration: BoxDecoration(
            gradient: AppTheme.getBackgroundGradient(appProvider.isDarkMode),
          ),
          padding: ResponsiveHelper.getScreenPadding(context),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Image
                CircleAvatar(
                  radius: ResponsiveHelper.getValue(
                    context, 
                    mobile: 60.0, 
                    tablet: 80.0, 
                    desktop: 100.0,
                  ),
                  backgroundImage: const AssetImage(AppConstants.defaultProfileImage),
                ),
                const SizedBox(height: 32),
                
                // Greeting
                Text(
                  l10n.heroGreeting,
                  style: AppTheme.getHeadingLarge(appProvider.isDarkMode).copyWith(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobile: 32,
                      tablet: 40,
                      desktop: 48,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  l10n.heroDescription,
                  style: AppTheme.getBodyLarge(appProvider.isDarkMode).copyWith(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
          //      const SizedBox(height: 32),
                
                // Skills Animation
               /* Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildSkillChip(l10n.heroSkill1),
                    _buildSkillChip(l10n.heroSkill2),
                    _buildSkillChip(l10n.heroSkill3),
                  ],
                ),*/
                const SizedBox(height: 48),
                
                // CTA Buttons
                ResponsiveHelper.isMobile(context)
                    ? Column(
                        children: [
                          _buildCTAButton(l10n.viewProjects, true),
                          const SizedBox(height: 16),
                          _buildCTAButton(l10n.contactMe, false),
                          const SizedBox(height: 20),
                          _buildMediumButton(context, appProvider),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCTAButton(l10n.viewProjects, true),
                              const SizedBox(width: 24),
                              _buildCTAButton(l10n.contactMe, false),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildMediumButton(context, appProvider),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Text(
        skill,
        style: AppTheme.labelMedium.copyWith(
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildCTAButton(String text, bool isPrimary) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        
        return SizedBox(
          width: 200,
          child: isPrimary
              ? ElevatedButton(
                  onPressed: () {
                    // "View Projects" butonu için projects section'a git (index 3)
                    if (text == l10n.viewProjects) {
                      appProvider.navigateToSection(3);
                    }
                  },
                  child: Text(text),
                )
              : OutlinedButton(
                  onPressed: () {
                    // "Connect me" butonu için contact section'a git (index 6)
                    if (text == l10n.contactMe) {
                      appProvider.navigateToSection(6);
                    }
                  },
                  child: Text(text),
                ),
        );
      },
    );
  }

  Widget _buildMediumButton(BuildContext context, AppProvider appProvider) {
    final l10n = AppLocalizations.of(context)!;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: ResponsiveHelper.isMobile(context) ? double.infinity : 250,
        child: ElevatedButton.icon(
          onPressed: () async {
            final Uri url = Uri.parse('https://medium.com/@alihasanov2023/freezed-m%C9%99ntiqi-v%C9%99-istifad%C9%99si-ali-hasanov-1ca3b6457460');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.article,
              color: Colors.black,
              size: 16,
            ),
          ),
          label: Text(
            l10n.readMediumArticles,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF000000),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.3),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.grey.withOpacity(0.1);
                }
                if (states.contains(WidgetState.pressed)) {
                  return Colors.grey.withOpacity(0.2);
                }
                return null;
              },
            ),
            elevation: WidgetStateProperty.resolveWith<double>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return 12;
                }
                if (states.contains(WidgetState.pressed)) {
                  return 4;
                }
                return 8;
              },
            ),
            animationDuration: const Duration(milliseconds: 200),
          ),
        ),
      ),
    );
  }
} 
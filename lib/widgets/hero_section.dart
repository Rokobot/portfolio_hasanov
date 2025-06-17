import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                const SizedBox(height: 32),
                
                // Skills Animation
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildSkillChip(l10n.heroSkill1),
                    _buildSkillChip(l10n.heroSkill2),
                    _buildSkillChip(l10n.heroSkill3),
                  ],
                ),
                const SizedBox(height: 48),
                
                // CTA Buttons
                ResponsiveHelper.isMobile(context)
                    ? Column(
                        children: [
                          _buildCTAButton(l10n.viewProjects, true),
                          const SizedBox(height: 16),
                          _buildCTAButton(l10n.contactMe, false),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCTAButton(l10n.viewProjects, true),
                          const SizedBox(width: 24),
                          _buildCTAButton(l10n.contactMe, false),
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
    return SizedBox(
      width: 200,
      child: isPrimary
          ? ElevatedButton(
              onPressed: () {},
              child: Text(text),
            )
          : OutlinedButton(
              onPressed: () {},
              child: Text(text),
            ),
    );
  }
} 
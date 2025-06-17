import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';
import '../constants/app_constants.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
          color: AppTheme.getSurfaceColor(appProvider.isDarkMode),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxContentWidth(context),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.aboutTitle,
                    style: AppTheme.getHeadingMedium(appProvider.isDarkMode),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.aboutDescription,
                    style: AppTheme.getBodyLarge(appProvider.isDarkMode),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    l10n.aboutEducation,
                    style: AppTheme.getBodyMedium(appProvider.isDarkMode).copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  ResponsiveHelper.isMobile(context)
                      ? Column(
                          children: [
                            _buildStatCard(context, AppConstants.yearsOfExperience.toString(), l10n.yearsExperience, appProvider.isDarkMode),
                            const SizedBox(height: 32),
                            _buildStatCard(context, AppConstants.totalProjects.toString(), l10n.projectsBuilt, appProvider.isDarkMode),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatCard(context, AppConstants.yearsOfExperience.toString(), l10n.yearsExperience, appProvider.isDarkMode),
                            _buildStatCard(context, AppConstants.totalProjects.toString(), l10n.projectsBuilt, appProvider.isDarkMode),
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

  Widget _buildStatCard(BuildContext context, String number, String label, bool isDarkMode) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 2000),
      tween: Tween<double>(begin: 0, end: double.parse(number)),
      builder: (context, value, child) {
        return Card(
          color: AppTheme.getCardColor(isDarkMode),
          elevation: 8,
          shadowColor: AppTheme.primaryColor.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  value.toInt().toString(),
                  style: AppTheme.getHeadingLarge(isDarkMode).copyWith(
                    color: AppTheme.primaryColor,
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobile: 36,
                      tablet: 42,
                      desktop: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: AppTheme.getBodyMedium(isDarkMode),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 
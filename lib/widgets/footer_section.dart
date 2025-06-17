import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';
import '../constants/app_constants.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getScreenPadding(context).copyWith(
        top: 40,
        bottom: 40,
      ),
      color: AppTheme.surfaceColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getMaxContentWidth(context),
          ),
          child: ResponsiveHelper.isMobile(context)
              ? _buildMobileLayout(context)
              : _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildSocialLinks(),
        const SizedBox(height: 24),
        _buildCopyright(),
        const SizedBox(height: 16),
        _buildMadeWith(),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCopyright(),
            const SizedBox(height: 8),
            _buildMadeWith(),
          ],
        ),
        _buildSocialLinks(),
      ],
    );
  }

  Widget _buildCopyright() {
    return Text(
      "© 2024 ${AppConstants.developerName}. All rights reserved.",
      style: AppTheme.bodySmall,
    );
  }

  Widget _buildMadeWith() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Made with ",
          style: AppTheme.bodySmall,
        ),
        Icon(
          Icons.favorite,
          size: 16,
          color: Colors.red,
        ),
        Text(
          " using Flutter Web",
          style: AppTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSocialButton(
          Icons.code,
          "GitHub",
          () {},
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          Icons.work,
          "LinkedIn",
          () {},
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          Icons.telegram,
          "Telegram",
          () {},
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          Icons.email,
          "Email",
          () {},
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
} 
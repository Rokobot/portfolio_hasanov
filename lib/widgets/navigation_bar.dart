import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';
import '../constants/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomNavigationBar extends StatefulWidget {
  final ScrollController? scrollController;
  
  const CustomNavigationBar({super.key, this.scrollController});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  double _scrollOffset = 0.0;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController != null) {
      setState(() {
        _scrollOffset = widget.scrollController!.offset;
        _isScrolled = _scrollOffset > 50;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: _isScrolled 
                ? AppTheme.getBackgroundColor(appProvider.isDarkMode).withOpacity(0.8)
                : AppTheme.getBackgroundColor(appProvider.isDarkMode).withOpacity(0.95),
            boxShadow: _isScrolled ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _isScrolled ? 20.0 : 0.0,
                sigmaY: _isScrolled ? 20.0 : 0.0,
              ),
              child: Container(
                padding: ResponsiveHelper.getScreenPadding(context).copyWith(
                  top: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                  color: _isScrolled 
                      ? AppTheme.getBackgroundColor(appProvider.isDarkMode).withOpacity(0.7)
                      : AppTheme.getBackgroundColor(appProvider.isDarkMode).withOpacity(0.95),
                  border: Border(
                    bottom: BorderSide(
                      color: _isScrolled 
                          ? AppTheme.primaryColor.withOpacity(0.2)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
                child: ResponsiveHelper.isMobile(context)
                    ? _buildMobileNavigation(context, appProvider)
                    : _buildDesktopNavigation(context, appProvider),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopNavigation(BuildContext context, AppProvider appProvider) {
    final l10n = AppLocalizations.of(context)!;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Text(
            AppConstants.developerName,
            style: AppTheme.getHeadingSmall(appProvider.isDarkMode).copyWith(
              color: AppTheme.primaryColor,
              fontSize: _isScrolled ? 18 : 20,
            ),
          ),
        ),
        
        // Navigation Links
        Row(
          children: [
            _buildNavItem(context, l10n.home, 0, appProvider),
            _buildNavItem(context, l10n.about, 1, appProvider),
            _buildNavItem(context, l10n.skills, 2, appProvider),
            _buildNavItem(context, l10n.projects, 3, appProvider),
            _buildNavItem(context, l10n.experience, 4, appProvider),
            _buildNavItem(context, l10n.github, 5, appProvider),
            _buildNavItem(context, l10n.contact, 6, appProvider),
          ],
        ),
        
        // Language & Theme Toggles
        Row(
          children: [
            _buildLanguageDropdown(context, appProvider),
            const SizedBox(width: 16),
            _buildThemeToggle(context, appProvider),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileNavigation(BuildContext context, AppProvider appProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Text(
            AppConstants.developerName,
            style: AppTheme.getHeadingSmall(appProvider.isDarkMode).copyWith(
              color: AppTheme.primaryColor,
              fontSize: _isScrolled ? 16 : 20,
            ),
          ),
        ),
        
        Row(
          children: [
            _buildLanguageDropdown(context, appProvider),
            const SizedBox(width: 8),
            _buildThemeToggle(context, appProvider),
            const SizedBox(width: 8),
            _buildMobileMenuButton(context, appProvider),
          ],
        ),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, String title, int index, AppProvider appProvider) {
    final isActive = appProvider.currentNavIndex == index;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () => appProvider.navigateToSection(index),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryColor.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(8),
            border: isActive && _isScrolled ? Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
              width: 1,
            ) : null,
          ),
          child: Text(
            title,
            style: AppTheme.getLabelLarge(appProvider.isDarkMode).copyWith(
              color: isActive ? AppTheme.primaryColor : AppTheme.getTextSecondaryColor(appProvider.isDarkMode),
              fontSize: _isScrolled ? 13 : 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context, AppProvider appProvider) {
    return Container(
      decoration: BoxDecoration(
        color: _isScrolled 
            ? AppTheme.getSurfaceColor(appProvider.isDarkMode).withOpacity(0.8) 
            : AppTheme.getSurfaceColor(appProvider.isDarkMode),
        borderRadius: BorderRadius.circular(8),
        border: _isScrolled ? Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ) : null,
      ),
      child: DropdownButton<Locale>(
        value: appProvider.currentLocale,
        dropdownColor: AppTheme.getSurfaceColor(appProvider.isDarkMode),
        underline: const SizedBox(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        icon: Icon(Icons.language, color: AppTheme.getTextSecondaryColor(appProvider.isDarkMode)),
        items: appProvider.availableLocales.entries.map((entry) {
          return DropdownMenuItem<Locale>(
            value: entry.key,
            child: Text(
              entry.value,
              style: AppTheme.getBodySmall(appProvider.isDarkMode).copyWith(
                color: AppTheme.getTextPrimaryColor(appProvider.isDarkMode)
              ),
            ),
          );
        }).toList(),
        onChanged: (locale) {
          if (locale != null) {
            appProvider.changeLocale(locale);
          }
        },
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, AppProvider appProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isScrolled ? AppTheme.primaryColor.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
        border: _isScrolled ? Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ) : null,
      ),
      child: IconButton(
        onPressed: appProvider.toggleTheme,
        icon: Icon(
          appProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: AppTheme.getTextSecondaryColor(appProvider.isDarkMode),
        ),
      ),
    );
  }

  Widget _buildMobileMenuButton(BuildContext context, AppProvider appProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isScrolled ? AppTheme.primaryColor.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
        border: _isScrolled ? Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ) : null,
      ),
      child: IconButton(
        onPressed: () => _showMobileMenu(context, appProvider),
        icon: Icon(
          Icons.menu,
          color: AppTheme.getTextSecondaryColor(appProvider.isDarkMode),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context, AppProvider appProvider) {
    final l10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.getSurfaceColor(appProvider.isDarkMode),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMobileNavItem(context, l10n.home, 0, appProvider),
              _buildMobileNavItem(context, l10n.about, 1, appProvider),
              _buildMobileNavItem(context, l10n.skills, 2, appProvider),
              _buildMobileNavItem(context, l10n.projects, 3, appProvider),
              _buildMobileNavItem(context, l10n.experience, 4, appProvider),
              _buildMobileNavItem(context, l10n.github, 5, appProvider),
              _buildMobileNavItem(context, l10n.contact, 6, appProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileNavItem(BuildContext context, String title, int index, AppProvider appProvider) {
    return ListTile(
      title: Text(
        title,
        style: AppTheme.getLabelLarge(appProvider.isDarkMode),
      ),
      onTap: () {
        Navigator.pop(context);
        appProvider.navigateToSection(index);
      },
    );
  }
} 
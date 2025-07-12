import 'package:flutter/material.dart';

class AppConstants {
  // Developer Information
  static const String developerName = 'Ali Hasanov';
  static const String developerTitle = 'Senior Flutter Developer';
  static const String githubUsername = 'alihasanov'; // Replace with actual GitHub username
  static const String githubUrl = 'https://github.com/$githubUsername';
  static const String linkedinUrl = 'https://linkedin.com/in/alihasanov'; // Replace with actual LinkedIn
  static const String telegramUrl = 'https://t.me/alihasanov'; // Replace with actual Telegram
  static const String whatsappNumber = '+994501234567'; // Replace with actual WhatsApp
  static const String email = 'ali.hasanov@email.com'; // Replace with actual email
  
  // Experience
  static const int yearsOfExperience = 3;
  static const int totalProjects = 9;
  
  // Assets Paths
  static const String defaultProfileImage = 'assets/images/profile_image.png';
  static const String defaultProjectImage = 'assets/images/default_project.png';
  static const String defaultSkillImage = 'assets/images/default_skill.png';
  static const String defaultGithubImage = 'assets/images/profile_image.png';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
  
  // Responsive Breakpoints
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1200;
  
  // Spacing
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;
  
  // Border Radius
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double extraLargeBorderRadius = 24.0;
  
  // URLs for Contact
  static String get whatsappUrl => 'https://wa.me/${whatsappNumber.replaceAll('+', '')}';
  static String get emailUrl => 'mailto:$email';
  static String get telegramContact => telegramUrl;
  
  // Localization
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('tr', 'TR'),
    Locale('az', 'AZ'),
    Locale('ru', 'RU'),
  ];
  
  // Default Locale
  static const Locale defaultLocale = Locale('en', 'US');
}

class AppStrings {
  // Navigation
  static const String home = 'home';
  static const String about = 'about';
  static const String skills = 'skills';
  static const String projects = 'projects';
  static const String experience = 'experience';
  static const String github = 'github';
  static const String contact = 'contact';
  
  // Hero Section
  static const String heroGreeting = 'heroGreeting';
  static const String heroDescription = 'heroDescription';
  static const String heroSkill1 = 'heroSkill1';
  static const String heroSkill2 = 'heroSkill2';
  static const String heroSkill3 = 'heroSkill3';
  static const String viewProjects = 'viewProjects';
  static const String contactMe = 'contactMe';
}

class AppAssets {
  // Images
  static const String defaultProfile = AppConstants.defaultProfileImage;
  static const String defaultProject = AppConstants.defaultProjectImage;
  static const String defaultSkill = AppConstants.defaultSkillImage;
  static const String defaultGithub = AppConstants.defaultGithubImage;
  
  // Data Files
  static const String skillsData = 'assets/data/skills.json';
  static const String projectsData = 'assets/data/projects.json';
  static const String experienceData = 'assets/data/experience.json';
} 
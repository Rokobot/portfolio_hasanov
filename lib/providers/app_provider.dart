import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class AppProvider extends ChangeNotifier {
  // Current locale
  Locale _currentLocale = AppConstants.defaultLocale;
  Locale get currentLocale => _currentLocale;

  // Theme mode
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  // Navigation
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  // Scroll controller for navigation
  final ScrollController scrollController = ScrollController();

  // Keys for navigation sections
  final GlobalKey homeKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey skillsKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey experienceKey = GlobalKey();
  final GlobalKey githubKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  AppProvider() {
    _loadPreferences();
  }

  // Load saved preferences
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load locale
      final savedLocale = prefs.getString('locale');
      if (savedLocale != null) {
        final parts = savedLocale.split('_');
        if (parts.length == 2) {
          _currentLocale = Locale(parts[0], parts[1]);
        }
      }
      
      // Load theme mode
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  // Change locale
  Future<void> changeLocale(Locale locale) async {
    if (_currentLocale == locale) return;
    
    _currentLocale = locale;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('locale', '${locale.languageCode}_${locale.countryCode}');
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  // Toggle theme mode
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  // Navigate to section
  void navigateToSection(int index) {
    _currentNavIndex = index;
    notifyListeners();
    
    // Scroll controller mevcut mu kontrol et
    if (!scrollController.hasClients) {
      debugPrint('ScrollController has no clients');
      return;
    }

    // Dinamik section pozisyonları (viewport height'e göre)
    final viewportHeight = scrollController.position.viewportDimension;
    final sectionHeight = viewportHeight * 0.8; // Her section yaklaşık ekranın %80'i
    
    final sectionPositions = [
      0.0,                           // Home
      sectionHeight * 1,             // About
      sectionHeight * 2,             // Skills  
      sectionHeight * 3,             // Projects
      sectionHeight * 4,             // Experience
      sectionHeight * 5,             // GitHub
      sectionHeight * 6,             // Contact
    ];

    if (index < sectionPositions.length) {
      final targetPosition = sectionPositions[index];
      final maxScroll = scrollController.position.maxScrollExtent;
      
      // Hedef pozisyonu maksimum scroll'a sınırla
      final adjustedPosition = targetPosition > maxScroll ? maxScroll : targetPosition;
      
      debugPrint('Navigating to section $index, position: $adjustedPosition');
      
      scrollController.animateTo(
        adjustedPosition,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  // Get available locales with names
  Map<Locale, String> get availableLocales => {
    const Locale('en', 'US'): 'English',
    const Locale('tr', 'TR'): 'Türkçe',
    const Locale('az', 'AZ'): 'Azərbaycan',
    const Locale('ru', 'RU'): 'Русский',
  };

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
} 
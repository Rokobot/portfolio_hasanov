import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../constants/app_constants.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Cache for loaded data
  List<Skill>? _cachedSkills;
  List<Project>? _cachedProjects;
  List<Experience>? _cachedExperience;

  /// Load skills from JSON file
  Future<List<Skill>> loadSkills() async {
    if (_cachedSkills != null) {
      return _cachedSkills!;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate loading
      
      final String jsonString = await rootBundle.loadString(AppAssets.skillsData);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      
      _cachedSkills = jsonList
          .map((json) => Skill.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return _cachedSkills!;
    } catch (e) {
      throw DataServiceException('Failed to load skills: $e');
    }
  }

  /// Load projects from JSON file
  Future<List<Project>> loadProjects() async {
    if (_cachedProjects != null) {
      return _cachedProjects!;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 1000)); // Simulate loading
      
      final String jsonString = await rootBundle.loadString(AppAssets.projectsData);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      
      _cachedProjects = jsonList
          .map((json) => Project.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return _cachedProjects!;
    } catch (e) {
      throw DataServiceException('Failed to load projects: $e');
    }
  }

  /// Load experience from JSON file
  Future<List<Experience>> loadExperience() async {
    if (_cachedExperience != null) {
      return _cachedExperience!;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 600)); // Simulate loading
      
      final String jsonString = await rootBundle.loadString(AppAssets.experienceData);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      
      _cachedExperience = jsonList
          .map((json) => Experience.fromJson(json as Map<String, dynamic>))
          .toList()
          ..sort((a, b) => b.startDate.compareTo(a.startDate)); // Sort by start date (newest first)
      
      return _cachedExperience!;
    } catch (e) {
      throw DataServiceException('Failed to load experience: $e');
    }
  }

  /// Get featured projects only
  Future<List<Project>> getFeaturedProjects() async {
    final projects = await loadProjects();
    return projects.where((project) => project.featured).toList();
  }

  /// Get skills by category
  Future<Map<String, List<Skill>>> getSkillsByCategory() async {
    final skills = await loadSkills();
    final Map<String, List<Skill>> categorizedSkills = {};
    
    for (final skill in skills) {
      if (!categorizedSkills.containsKey(skill.category)) {
        categorizedSkills[skill.category] = [];
      }
      categorizedSkills[skill.category]!.add(skill);
    }
    
    return categorizedSkills;
  }

  /// Get current job experience
  Future<Experience?> getCurrentJob() async {
    final experiences = await loadExperience();
    try {
      return experiences.firstWhere((exp) => exp.isCurrentJob);
    } catch (e) {
      return null; // No current job found
    }
  }

  /// Get total years of experience
  Future<int> getTotalYearsOfExperience() async {
    final experiences = await loadExperience();
    if (experiences.isEmpty) return 0;
    
    final oldestJob = experiences.reduce((a, b) => 
        a.startDate.isBefore(b.startDate) ? a : b);
    
    final now = DateTime.now();
    final totalDays = now.difference(oldestJob.startDate).inDays;
    return (totalDays / 365).floor();
  }

  /// Clear all cached data
  void clearCache() {
    _cachedSkills = null;
    _cachedProjects = null;
    _cachedExperience = null;
  }

  /// Refresh data (clear cache and reload)
  Future<void> refreshData() async {
    clearCache();
    await Future.wait([
      loadSkills(),
      loadProjects(),
      loadExperience(),
    ]);
  }
}

class DataServiceException implements Exception {
  final String message;
  const DataServiceException(this.message);
  
  @override
  String toString() => 'DataServiceException: $message';
} 
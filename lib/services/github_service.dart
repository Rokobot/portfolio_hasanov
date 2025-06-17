import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/github_user.dart';
import '../constants/app_constants.dart';

class GitHubService {
  static final GitHubService _instance = GitHubService._internal();
  factory GitHubService() => _instance;
  GitHubService._internal();

  static const String _baseUrl = 'https://api.github.com';
  static const Duration _timeout = Duration(seconds: 10);

  // Cache for GitHub data
  GitHubUser? _cachedUser;
  List<GitHubRepository>? _cachedRepositories;
  DateTime? _lastCacheTime;
  static const Duration _cacheValidDuration = Duration(minutes: 15);

  /// Check if cache is still valid
  bool get _isCacheValid {
    if (_lastCacheTime == null) return false;
    return DateTime.now().difference(_lastCacheTime!) < _cacheValidDuration;
  }

  /// Get GitHub user profile
  Future<GitHubUser> getUserProfile([String? username]) async {
    final targetUsername = username ?? AppConstants.githubUsername;
    
    if (_cachedUser != null && _isCacheValid) {
      return _cachedUser!;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
      
      final response = await http
          .get(
            Uri.parse('$_baseUrl/users/$targetUsername'),
            headers: {'Accept': 'application/vnd.github.v3+json'},
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        _cachedUser = GitHubUser.fromJson(jsonData);
        _lastCacheTime = DateTime.now();
        return _cachedUser!;
      } else if (response.statusCode == 404) {
        throw GitHubServiceException('GitHub user not found: $targetUsername');
      } else {
        throw GitHubServiceException(
          'Failed to fetch GitHub user: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw GitHubServiceException('Request timeout while fetching GitHub user');
    } catch (e) {
      if (e is GitHubServiceException) rethrow;
      throw GitHubServiceException('Network error while fetching GitHub user: $e');
    }
  }

  /// Get user repositories
  Future<List<GitHubRepository>> getUserRepositories([String? username]) async {
    final targetUsername = username ?? AppConstants.githubUsername;
    
    if (_cachedRepositories != null && _isCacheValid) {
      return _cachedRepositories!;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 700)); // Simulate loading
      
      final response = await http
          .get(
            Uri.parse('$_baseUrl/users/$targetUsername/repos?sort=updated&per_page=20'),
            headers: {'Accept': 'application/vnd.github.v3+json'},
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
        _cachedRepositories = jsonList
            .map((json) => GitHubRepository.fromJson(json as Map<String, dynamic>))
            .where((repo) => !repo.fork) // Filter out forked repositories
            .toList()
          ..sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount)); // Sort by stars
        
        _lastCacheTime = DateTime.now();
        return _cachedRepositories!;
      } else if (response.statusCode == 404) {
        throw GitHubServiceException('GitHub user repositories not found: $targetUsername');
      } else {
        throw GitHubServiceException(
          'Failed to fetch repositories: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw GitHubServiceException('Request timeout while fetching repositories');
    } catch (e) {
      if (e is GitHubServiceException) rethrow;
      throw GitHubServiceException('Network error while fetching repositories: $e');
    }
  }

  /// Get top repositories (by stars)
  Future<List<GitHubRepository>> getTopRepositories([String? username, int limit = 6]) async {
    final repositories = await getUserRepositories(username);
    return repositories.take(limit).toList();
  }

  /// Get repositories by language
  Future<List<GitHubRepository>> getRepositoriesByLanguage(
    String language, [
    String? username,
  ]) async {
    final repositories = await getUserRepositories(username);
    return repositories
        .where((repo) => repo.language.toLowerCase() == language.toLowerCase())
        .toList();
  }

  /// Get GitHub profile statistics
  Future<GitHubStats> getGitHubStats([String? username]) async {
    final user = await getUserProfile(username);
    final repositories = await getUserRepositories(username);
    
    final totalStars = repositories.fold<int>(
      0, 
      (sum, repo) => sum + repo.stargazersCount,
    );
    
    final totalForks = repositories.fold<int>(
      0, 
      (sum, repo) => sum + repo.forksCount,
    );
    
    final languages = <String, int>{};
    for (final repo in repositories) {
      if (repo.language.isNotEmpty && repo.language != 'Unknown') {
        languages[repo.language] = (languages[repo.language] ?? 0) + 1;
      }
    }
    
    return GitHubStats(
      totalRepositories: user.publicRepos,
      totalStars: totalStars,
      totalForks: totalForks,
      followers: user.followers,
      following: user.following,
      topLanguages: languages,
    );
  }

  /// Clear cached data
  void clearCache() {
    _cachedUser = null;
    _cachedRepositories = null;
    _lastCacheTime = null;
  }

  /// Refresh GitHub data
  Future<void> refreshData([String? username]) async {
    clearCache();
    await Future.wait([
      getUserProfile(username),
      getUserRepositories(username),
    ]);
  }
}

class GitHubStats {
  final int totalRepositories;
  final int totalStars;
  final int totalForks;
  final int followers;
  final int following;
  final Map<String, int> topLanguages;

  const GitHubStats({
    required this.totalRepositories,
    required this.totalStars,
    required this.totalForks,
    required this.followers,
    required this.following,
    required this.topLanguages,
  });

  String get topLanguage => topLanguages.isEmpty 
      ? 'Unknown' 
      : topLanguages.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
}

class GitHubServiceException implements Exception {
  final String message;
  const GitHubServiceException(this.message);
  
  @override
  String toString() => 'GitHubServiceException: $message';
} 
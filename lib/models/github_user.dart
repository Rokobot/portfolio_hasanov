class GitHubUser {
  final String login;
  final int id;
  final String avatarUrl;
  final String htmlUrl;
  final String? name;
  final String? bio;
  final String? location;
  final String? email;
  final String? blog;
  final int publicRepos;
  final int followers;
  final int following;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GitHubUser({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.htmlUrl,
    this.name,
    this.bio,
    this.location,
    this.email,
    this.blog,
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      login: json['login'] as String,
      id: json['id'] as int,
      avatarUrl: json['avatar_url'] as String,
      htmlUrl: json['html_url'] as String,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      email: json['email'] as String?,
      blog: json['blog'] as String?,
      publicRepos: json['public_repos'] as int,
      followers: json['followers'] as int,
      following: json['following'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
      'name': name,
      'bio': bio,
      'location': location,
      'email': email,
      'blog': blog,
      'public_repos': publicRepos,
      'followers': followers,
      'following': following,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayName => name ?? login;
  bool get hasBio => bio != null && bio!.isNotEmpty;
  bool get hasBlog => blog != null && blog!.isNotEmpty;
  bool get hasLocation => location != null && location!.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GitHubUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GitHubUser(login: $login, name: $name, publicRepos: $publicRepos)';
  }
}

class GitHubRepository {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final String htmlUrl;
  final String language;
  final int stargazersCount;
  final int forksCount;
  final bool fork;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GitHubRepository({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.htmlUrl,
    required this.language,
    required this.stargazersCount,
    required this.forksCount,
    required this.fork,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      id: json['id'] as int,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      description: json['description'] as String?,
      htmlUrl: json['html_url'] as String,
      language: json['language'] as String? ?? 'Unknown',
      stargazersCount: json['stargazers_count'] as int,
      forksCount: json['forks_count'] as int,
      fork: json['fork'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'description': description,
      'html_url': htmlUrl,
      'language': language,
      'stargazers_count': stargazersCount,
      'forks_count': forksCount,
      'fork': fork,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get hasDescription => description != null && description!.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GitHubRepository && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GitHubRepository(name: $name, language: $language, stars: $stargazersCount)';
  }
} 
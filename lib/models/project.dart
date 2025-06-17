class Project {
  final int id;
  final String title;
  final String description;
  final String image;
  final List<String> technologies;
  final String githubUrl;
  final String liveUrl;
  final bool featured;
  final int year;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.technologies,
    required this.githubUrl,
    required this.liveUrl,
    required this.featured,
    required this.year,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      githubUrl: json['githubUrl'] as String,
      liveUrl: json['liveUrl'] as String,
      featured: json['featured'] as bool,
      year: json['year'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'technologies': technologies,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
      'featured': featured,
      'year': year,
    };
  }

  bool get hasLiveUrl => liveUrl.isNotEmpty;
  bool get hasGithubUrl => githubUrl.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Project(id: $id, title: $title, year: $year, featured: $featured)';
  }
} 
class Skill {
  final int id;
  final String name;
  final int level;
  final String category;
  final String icon;

  const Skill({
    required this.id,
    required this.name,
    required this.level,
    required this.category,
    required this.icon,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as int,
      name: json['name'] as String,
      level: json['level'] as int,
      category: json['category'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'category': category,
      'icon': icon,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Skill && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Skill(id: $id, name: $name, level: $level, category: $category)';
  }
} 
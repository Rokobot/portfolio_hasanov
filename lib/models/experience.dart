class Experience {
  final int id;
  final String company;
  final String position;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentJob;
  final String location;
  final String description;
  final List<String> technologies;
  final List<String> achievements;

  const Experience({
    required this.id,
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.isCurrentJob,
    required this.location,
    required this.description,
    required this.technologies,
    required this.achievements,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] as int,
      company: json['company'] as String,
      position: json['position'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String)
          : null,
      isCurrentJob: json['isCurrentJob'] as bool,
      location: json['location'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      achievements: List<String>.from(json['achievements'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'position': position,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrentJob': isCurrentJob,
      'location': location,
      'description': description,
      'technologies': technologies,
      'achievements': achievements,
    };
  }

  String get duration {
    final start = startDate;
    final end = endDate ?? DateTime.now();
    
    final years = end.difference(start).inDays ~/ 365;
    final months = (end.difference(start).inDays % 365) ~/ 30;
    
    if (years > 0 && months > 0) {
      return '$years yr ${months} mo';
    } else if (years > 0) {
      return '$years yr';
    } else if (months > 0) {
      return '$months mo';
    } else {
      return '< 1 mo';
    }
  }

  String get formattedStartDate => '${_monthNames[startDate.month - 1]} ${startDate.year}';
  String get formattedEndDate => 
      endDate != null 
          ? '${_monthNames[endDate!.month - 1]} ${endDate!.year}'
          : 'Present';

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Experience && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Experience(id: $id, company: $company, position: $position, duration: $duration)';
  }
} 
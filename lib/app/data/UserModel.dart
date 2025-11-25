// ignore_for_file: file_names

class UserModel {
  final int id;
  final String name;
  final String email;

  final DateTime? birthDate;
  final int? height;
  final int? weight;
  final String? mainGoal;
  final num? weightGoal;
  final String? activityLevel;
  final String? gender;
  final List<String> allergies;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.birthDate,
    this.height,
    this.weight,
    this.mainGoal,
    this.weightGoal,
    this.activityLevel,
    this.gender,
    this.allergies = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'])
          : null,
      height: json['height'],
      weight: json['weight'],
      mainGoal: json['mainGoal'],
      weightGoal: json['weightGoal'],
      activityLevel: json['activityLevel'],
      gender: json['gender'],
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'birthDate': birthDate?.toIso8601String(),
      'height': height,
      'weight': weight,
      'mainGoal': mainGoal,
      'weightGoal': weightGoal,
      'activityLevel': activityLevel,
      'gender': gender,
      'allergies': allergies,
    };
  }
}

class UserModel {
  final String name;
  final String greeting;
  final String subtitle;
  final String avatarUrl;

  UserModel({
    required this.name,
    required this.greeting,
    required this.subtitle,
    required this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'] ?? '',
    greeting: json['greeting'] ?? '',
    subtitle: json['subtitle'] ?? '',
    avatarUrl: json['avatarUrl'] ?? '',
  );
}

class HealthService {
  final String id;
  final String name;
  final String iconUrl;

  HealthService({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory HealthService.fromJson(Map<String, dynamic> json) => HealthService(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    iconUrl: json['iconUrl'] ?? '',
  );
}

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String distance;
  final String avatarUrl;
  final bool isFavorite;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.distance = '',
    required this.avatarUrl,
    this.isFavorite = false,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    specialty: json['specialty'] ?? '',
    distance: json['distance'] ?? '',
    avatarUrl: json['avatarUrl'] ?? '',
    isFavorite: json['isFavorite'] ?? false,
  );

  DoctorModel copyWith({bool? isFavorite}) {
    return DoctorModel(
      id: id,
      name: name,
      specialty: specialty,
      distance: distance,
      avatarUrl: avatarUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
/// Application user model (Phase 1: stored in mock/local auth service).
class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.bloodGroup,
    required this.area,
    this.city = 'Hyderabad',
    this.age,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String bloodGroup; // e.g. 'O+'
  final String area; // e.g. 'Kukatpally'
  final String city;
  final int? age; // donor age for eligibility (Phase 2)

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  AppUser copyWith({
    String? fullName,
    String? phone,
    String? bloodGroup,
    String? area,
    String? city,
    int? age,
  }) {
    return AppUser(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      phone: phone ?? this.phone,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      area: area ?? this.area,
      city: city ?? this.city,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'bloodGroup': bloodGroup,
        'area': area,
        'city': city,
        'age': age,
      };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        id: map['id'] as String,
        fullName: map['fullName'] as String,
        email: map['email'] as String,
        phone: map['phone'] as String,
        bloodGroup: map['bloodGroup'] as String,
        area: map['area'] as String,
        city: map['city'] as String? ?? 'Hyderabad',
        age: (map['age'] as num?)?.toInt(),
      );
}

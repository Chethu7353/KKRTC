enum UserRole { passenger, pilot }

class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final UserRole role;
  final String preferredLanguage;

  const UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email = '',
    this.role = UserRole.passenger,
    this.preferredLanguage = 'en',
  });

  bool get isPilot => role == UserRole.pilot;
}

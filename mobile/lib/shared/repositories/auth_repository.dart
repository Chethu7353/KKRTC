import '../models/user_model.dart';

abstract class AuthRepository {
  Future<bool> sendOtp(String phoneNumber);
  Future<UserModel> verifyOtp(String phoneNumber, String otp);
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
}

/// Demonstration Mock Authentication Repository
/// Isolated and ready for swap with Django REST JWT backend
class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;

  @override
  Future<bool> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return phoneNumber.length >= 10;
  }

  @override
  Future<UserModel> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _currentUser = UserModel(
      id: 'usr_demo_01',
      name: 'Ramesh Gouda',
      phoneNumber: phoneNumber,
      email: 'ramesh.gouda@example.com',
      role: UserRole.passenger,
    );
    return _currentUser!;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser ??
        const UserModel(
          id: 'usr_demo_01',
          name: 'Ramesh Gouda',
          phoneNumber: '+91 98450 12345',
          email: 'ramesh.gouda@example.com',
          role: UserRole.passenger,
        );
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}

class AuthMockDataSource {
  static const String _fixedOtp = '1234';

  Future<void> sendOtp(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<bool> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return code == _fixedOtp;
  }
}

class ApiConfig {
  static const String _baseUrl = 'https://ola-api.onrender.com';

  static String smartLogin() {
    return '$_baseUrl/proteaMetering/login-v2';
  }

  static String login() {
    return '$_baseUrl/proteaMetering/login';
  }


  static String buyElectricity() {
    return '$_baseUrl/proteaMetering/buyElectricity';
  }

  static String oldPassword(String username) {
    return '$_baseUrl/proteaMetering/oldPassword/$username';
  }

  static String resetPassword(String username) {
    return '$_baseUrl/proteaMetering/resetPassword/$username';
  }

  static String topUp() {
    return '$_baseUrl/proteaMetering/topup';
  }

  static String statementV2() {
    return '$_baseUrl/proteaMetering/statementV2';
  }
}
class ApiConfig {
  static const String baseUrl = 'https://ola-api.onrender.com//proteaMetering';
  //static const String baseUrl = 'http://localhost:3000/proteaMetering';

  // Authentication Endpoints
  static String oldPassword(String username) => '$baseUrl/old-password?username=$username';
  static String resetPassword(String username) => '$baseUrl/request-new-password?username=$username';
  static String login() => '$baseUrl/login';
  
  // Electricity Endpoints
  static String buyElectricity() => '$baseUrl/buy-electricity';
  
  // Add more endpoint methods as needed
}
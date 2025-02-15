class ApiEndpoints {
  ApiEndpoints._();

  // Duration constants for connection and receive timeout
  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  // Define the IP address (easier to change here)
  static const String ipAddress = "192.168.1.69";

  // Base URL for API requests
  static String get baseUrl => "http://$ipAddress:5000/api/";

  // Image URL for uploads and access
  static String get imageUrl => "http://$ipAddress:5000/uploads/";

  // ====================== Auth Routes ======================
  static const String login = "user/login";
  static const String register = "user";
  static const String uploadImage = "user/uploadImage";

  // ====================== User Details Routes ======================
  static const String addUserDetails = "details";
  static const String getUserDetails = "details/getUserDetails";
}

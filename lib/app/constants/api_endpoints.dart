class ApiEndpoints {
  ApiEndpoints._();

  // Duration constants for connection and receive timeout
  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  static const String ipAddress = "192.168.1.69";
  static String get baseUrl => "http://$ipAddress:5000/api/"; // Backend API
  static String get profilePhotoUrl => "http://$ipAddress:5173/profilePhotos/"; // Frontend server
  static String get userImageUrl => "http://$ipAddress:5173/userImages/"; // Frontend server
  // ====================== Auth Routes ======================
  static const String login = "auth/login";
  static const String currentUser = "auth/me";
  static const String register = "auth/signup";
  static const String uploadImage = "auth/uploadImage";

  // ====================== User Details Routes ======================
  static const String addUserDetails = "userDetails/add";
  static const String updateUserDetails = "userDetails/";
  static const String getUserDetails = "userDetails/user";

  // ====================== Match Routes ======================
  static const String getUsers = "/matches/user-profiles";
}

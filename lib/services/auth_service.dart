import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Ganti dengan IP/URL Laravel Anda
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String loginEndpoint = '$baseUrl/api/login';

  // Mapping role_id ke role name
  static const Map<int, String> roleMapping = {
    1: 'admin',
    2: 'penyuluh',
    3: 'petani',
  };

  // Simpan token dan user data
  static String? _authToken;
  static String? _userName;
  static String? _userEmail;
  static String? _userVillage;
  static int? _userId;

  static String? get authToken => _authToken;
  static String? get userName => _userName;
  static String? get userEmail => _userEmail;
  static String? get userVillage => _userVillage;
  static int? get userId => _userId;

  static Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('=== LOGIN DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed Data: $data');
        
        final user = data['user'];
        final roleId = user?['role_id'] as int?;
        final roleName = roleId != null ? roleMapping[roleId] : null;
        
        print('Role ID dari API: $roleId');
        print('Role Name (mapped): $roleName');
        
        _authToken = data['access_token']; // Simpan token
        _userName = user?['name'] as String?; // Simpan nama user
        _userEmail = user?['email'] as String?; // Simpan email user
        _userId = user?['id'] as int?; // Simpan ID user
        _userVillage = user?['village']?['name'] as String? ?? 'Unknown'; // Simpan nama desa
        
        print('User Name: $_userName, Village: $_userVillage');
        
        return LoginResponse(
          success: true,
          message: data['message'] ?? 'Login berhasil',
          token: data['access_token'],
          user: user,
          role: roleName, // Gunakan role name yang sudah di-map
        );
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        final data = jsonDecode(response.body);
        String errorMessage = data['message'] ?? 'Username atau password salah';
        
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError.first.toString();
            } else {
              errorMessage = firstError.toString();
            }
          }
        }

        return LoginResponse(
          success: false,
          message: errorMessage,
        );
      } else {
        String errorMsg = 'Terjadi kesalahan server (${response.statusCode})';
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) {
            errorMsg = data['message'];
          }
        } catch (_) {}

        return LoginResponse(
          success: false,
          message: errorMsg,
        );
      }
    } catch (e) {
      print('Error: $e');
      return LoginResponse(
        success: false,
        message: 'Gagal terhubung ke server: $e',
      );
    }
  }

  // Fetch petani's village from new endpoint
  static Future<String> getPetaniVillage() async {
    try {
      print('=== FETCHING VILLAGE ===');
      print('Token: $authToken');
      print('URL: $baseUrl/api/petani/village');

      final response = await http.get(
        Uri.parse('$baseUrl/api/petani/village'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print('=== VILLAGE DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed Data: $data');
        final villageData = data['data'] as Map<String, dynamic>? ?? {};
        print('Village Data: $villageData');
        final villageName = villageData['village_name'] as String? ?? 'Unknown';
        print('Village Name: $villageName');
        return villageName;
      } else {
        print('Error: Status ${response.statusCode}');
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching village: $e');
      return 'Unknown';
    }
  }

  // Logout and call API endpoint
  static Future<bool> logout() async {
    try {
      if (_authToken == null) {
        // Token sudah kosong (misal karena hot restart), langsung bersihkan state
        _userName = null;
        _userEmail = null;
        _userId = null;
        _userVillage = null;
        return true;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      print('=== LOGOUT DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Clear local data regardless of API response
      _authToken = null;
      _userName = null;
      _userEmail = null;
      _userId = null;
      _userVillage = null;

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error during logout: $e');
      // Clear local data even if request fails
      _authToken = null;
      _userName = null;
      _userEmail = null;
      _userId = null;
      _userVillage = null;
      return false;
    }
  }
  // Forgot Password: Step 1 - Send OTP to email
  static Future<Map<String, dynamic>> sendOtpForPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/request-otp-for-reset'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  // Forgot Password: Step 2 - Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  // Forgot Password: Step 3 - Reset Password
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/reset-password-with-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': 'Gagal terhubung ke server: $e'};
    }
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final String? token;
  final dynamic user;
  final String? role;

  LoginResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
    this.role,
  });
}

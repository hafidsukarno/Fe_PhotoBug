import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl = 'http://localhost:8000';
  static const String registerEndpoint = '$baseUrl/api/register';
  static const String villagesEndpoint = '$baseUrl/api/villages';

  // Fetch daftar desa dari API
  static Future<List<Village>> getVillages() async {
    try {
      final response = await http.get(
        Uri.parse(villagesEndpoint),
        headers: {
          'Accept': 'application/json',
        },
      );

      print('=== FETCH VILLAGES DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle response format dari Laravel
        List<dynamic> villageList = [];
        
        // Jika response punya struktur { data: [...] }
        if (data is Map && data.containsKey('data')) {
          villageList = data['data'] as List<dynamic>;
        } else if (data is List) {
          villageList = data;
        }

        print('Villages fetched: ${villageList.length}');
        
        return villageList
            .map((v) => Village.fromJson(v as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load villages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching villages: $e');
      return [];
    }
  }

  // Register user
  static Future<RegisterResponse> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String noHp,
    required int villageId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(registerEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'no_hp': noHp,
          'village_id': villageId,
        }),
      );

      print('=== REGISTER DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return RegisterResponse(
          success: true,
          message: data['message'] ?? 'Registrasi berhasil!',
          user: data['user'],
        );
      } else if (response.statusCode == 422) {
        final data = jsonDecode(response.body);
        String errorMsg = data['message'] ?? 'Validasi gagal';
        
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMsg = firstError.first.toString();
            } else {
              errorMsg = firstError.toString();
            }
          }
        }
        
        return RegisterResponse(
          success: false,
          message: errorMsg,
        );
      } else {
        String errorMsg = 'Registrasi gagal (${response.statusCode})';
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) {
            errorMsg = data['message'];
          }
        } catch (_) {}

        return RegisterResponse(
          success: false,
          message: errorMsg,
        );
      }
    } catch (e) {
      print('Error: $e');
      return RegisterResponse(
        success: false,
        message: 'Gagal terhubung ke server: $e',
      );
    }
  }
}

class Village {
  final int id;
  final String name;

  Village({
    required this.id,
    required this.name,
  });

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'] as int? ?? 0,
      // Ambil dari 'village_name' jika ada, fallback ke 'name'
      name: json['village_name'] as String? ?? json['name'] as String? ?? 'Unknown',
    );
  }

  @override
  String toString() => name;
}

class RegisterResponse {
  final bool success;
  final String message;
  final dynamic user;

  RegisterResponse({
    required this.success,
    required this.message,
    this.user,
  });
}

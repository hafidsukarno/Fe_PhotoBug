import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_photobug/services/auth_service.dart';

class AdminDashboardData {
  final int totalUsers;
  final int activeUsers;
  final int totalReports;
  final int pendingReview;
  final int completed;

  AdminDashboardData({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalReports,
    required this.pendingReview,
    required this.completed,
  });

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) {
    return AdminDashboardData(
      totalUsers: json['total_users'] ?? 0,
      activeUsers: json['active_users'] ?? 0,
      totalReports: json['total_reports'] ?? 0,
      pendingReview: json['pending_review'] ?? 0,
      completed: json['completed'] ?? 0,
    );
  }
}

class VillageReportItem {
  final int id;
  final String villageName;
  final String district;
  final String penyuluhName;
  final int? penyuluhId;
  final int totalReports;
  final int totalPestsDetected;

  VillageReportItem({
    required this.id,
    required this.villageName,
    required this.district,
    required this.penyuluhName,
    this.penyuluhId,
    required this.totalReports,
    required this.totalPestsDetected,
  });

  factory VillageReportItem.fromJson(Map<String, dynamic> json) {
    return VillageReportItem(
      id: json['id'] ?? 0,
      villageName: json['village_name']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      penyuluhName: json['penyuluh_name']?.toString() ?? '',
      penyuluhId: json['penyuluh_id'],
      totalReports: json['total_reports'] ?? 0,
      totalPestsDetected: json['total_pests_detected'] ?? 0,
    );
  }
}

class VillagesReportData {
  final int totalVillages;
  final List<VillageReportItem> data;

  VillagesReportData({
    required this.totalVillages,
    required this.data,
  });
}

class PestStatisticsData {
  final Map<String, int> summary;

  PestStatisticsData({
    required this.summary,
  });
}

class Village {
  final int id;
  final String villageName;
  final String district;

  Village({
    required this.id,
    required this.villageName,
    required this.district,
  });

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'] ?? 0,
      villageName: json['village_name']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
    );
  }
}

class PenyuluhItem {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? noHp;
  final List<String> managedVillages;

  PenyuluhItem({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.noHp,
    required this.managedVillages,
  });

  factory PenyuluhItem.fromJson(Map<String, dynamic> json) {
    final list = json['managed_villages'] as List? ?? [];
    final villages = list.map((e) => e['village_name']?.toString() ?? '').toList();
    
    return PenyuluhItem(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      noHp: json['no_hp']?.toString(),
      managedVillages: villages,
    );
  }
}

class AdminService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<AdminDashboardData?> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/dashboard'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return AdminDashboardData.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error getDashboardStats: $e');
      return null;
    }
  }

  static Future<VillagesReportData?> getVillagesReport() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/villages-report'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final List list = data['data'] ?? [];
          final items = list.map((e) => VillageReportItem.fromJson(e)).toList();
          return VillagesReportData(
            totalVillages: data['total_villages'] ?? 0,
            data: items,
          );
        }
      }
      return null;
    } catch (e) {
      print('Error getVillagesReport: $e');
      return null;
    }
  }

  static Future<PestStatisticsData?> getPestStatistics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/pest-statistics'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final Map<String, dynamic> rawSummary = data['summary'] ?? {};
          final summary = rawSummary.map((key, value) => MapEntry(key, int.tryParse(value.toString()) ?? 0));
          return PestStatisticsData(summary: summary);
        }
      }
      return null;
    } catch (e) {
      print('Error getPestStatistics: $e');
      return null;
    }
  }

  // ==================== VILLAGE CRUD ====================

  static Future<List<Village>> getVillages() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/villages'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final List list = data['data'] ?? [];
          return list.map((e) => Village.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getVillages: $e');
      return [];
    }
  }

  static Future<Map<String, String>> getVillagesStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/villages-status'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final List list = data['data'] ?? [];
          final Map<String, String> statusMap = {};
          for (var item in list) {
            final name = item['village_name']?.toString() ?? '';
            final status = item['status']?.toString() ?? '';
            if (name.isNotEmpty) {
              statusMap[name] = status;
            }
          }
          return statusMap;
        }
      }
      return {};
    } catch (e) {
      print('Error getVillagesStatus: $e');
      return {};
    }
  }

  static Future<String?> createVillage(String name, String district) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/admin/villages'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
        body: jsonEncode({
          'village_name': name,
          'district': district,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) return null;
      try {
        final data = jsonDecode(response.body);
        if (data['message'] != null) return data['message'].toString();
      } catch (_) {}
      return 'Gagal menambahkan desa';
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  static Future<String?> updateVillage(int id, String name, String district) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/villages/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
        body: jsonEncode({
          'village_name': name,
          'district': district,
        }),
      );

      if (response.statusCode == 200) return null;
      try {
        final data = jsonDecode(response.body);
        if (data['message'] != null) return data['message'].toString();
      } catch (_) {}
      return 'Gagal mengupdate desa';
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  static Future<String?> deleteVillage(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/admin/villages/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) return null;
      try {
        final data = jsonDecode(response.body);
        if (data['message'] != null) return data['message'].toString();
      } catch (_) {}
      return 'Gagal menghapus desa';
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  // ==================== PENYULUH CRUD ====================

  static Future<List<PenyuluhItem>> getPenyuluhList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/penyuluh'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((e) => PenyuluhItem.fromJson(e)).toList();
        } else if (data is Map && data['data'] is List) {
          return (data['data'] as List).map((e) => PenyuluhItem.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getPenyuluhList: $e');
      return [];
    }
  }

  static Future<String?> createPenyuluh({
    required String name,
    required String username,
    required String email,
    required String password,
    required String noHp,
    required List<int> villages,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/admin/penyuluh'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
        body: jsonEncode({
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'no_hp': noHp.trim().isEmpty ? null : noHp.trim(),
          'villages': villages,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return null; // success
      } else {
        print('Failed createPenyuluh. Status: ${response.statusCode}, Body: ${response.body}');
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) return data['message'].toString();
          if (data['error'] != null) return data['error'].toString();
        } catch (_) {}
        return 'Gagal membuat penyuluh (Status: ${response.statusCode})';
      }
    } catch (e) {
      print('Error createPenyuluh: $e');
      return 'Terjadi kesalahan sistem: $e';
    }
  }

  static Future<String?> updatePenyuluh({
    required int id,
    required String name,
    required String username,
    required String email,
    required String password,
    required String noHp,
    required List<int> villages,
  }) async {
    try {
      final body = {
        'name': name,
        'username': username,
        'email': email,
        'no_hp': noHp.trim().isEmpty ? null : noHp.trim(),
        'villages': villages,
      };
      // Password is optional for update
      if (password.isNotEmpty) {
        body['password'] = password;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/penyuluh/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return null; // success
      } else {
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) return data['message'].toString();
          if (data['error'] != null) return data['error'].toString();
        } catch (_) {}
        return 'Gagal memperbarui penyuluh (Status: ${response.statusCode})';
      }
    } catch (e) {
      return 'Terjadi kesalahan sistem: $e';
    }
  }

  static Future<String?> deletePenyuluh(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/admin/penyuluh/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        return null; // success
      } else {
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) return data['message'].toString();
          if (data['error'] != null) return data['error'].toString();
        } catch (_) {}
        return 'Gagal menghapus penyuluh (Status: ${response.statusCode})';
      }
    } catch (e) {
      return 'Terjadi kesalahan sistem: $e';
    }
  }
}

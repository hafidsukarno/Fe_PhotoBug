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
}

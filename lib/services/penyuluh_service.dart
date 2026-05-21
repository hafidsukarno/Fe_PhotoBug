import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_photobug/services/auth_service.dart';

class PenyuluhReportStatusResponse {
  final bool success;
  final String? message;
  final int totalIncoming;
  final int waitingVerification;
  final int completed;

  PenyuluhReportStatusResponse({
    required this.success,
    this.message,
    this.totalIncoming = 0,
    this.waitingVerification = 0,
    this.completed = 0,
  });
}

class PenyuluhReportItem {
  final int id;
  final String imagePath;
  final String petaniName;
  final String villageName;
  final String pestName;
  final String confidence;
  final String status;
  final String detectedAt;

  PenyuluhReportItem({
    required this.id,
    required this.imagePath,
    required this.petaniName,
    required this.villageName,
    required this.pestName,
    required this.confidence,
    required this.status,
    required this.detectedAt,
  });
}

class PenyuluhReportResponse {
  final bool success;
  final String? message;
  final int total;
  final int pendingCount;
  final int completedCount;
  final List<PenyuluhReportItem> data;

  PenyuluhReportResponse({
    required this.success,
    this.message,
    this.total = 0,
    this.pendingCount = 0,
    this.completedCount = 0,
    this.data = const [],
  });
}

class PenyuluhReportDetail {
  final int id;
  final String petaniName;
  final String? petaniEmail;
  final String villageName;
  final String description;
  final String imagePath;
  final String pestName;
  final String highestConfidence;
  final int pestCount;
  final String aiRecommendation;
  final String? penyuluhRecommendation;
  final String status;
  final String detectedAt;

  PenyuluhReportDetail({
    required this.id,
    required this.petaniName,
    this.petaniEmail,
    required this.villageName,
    required this.description,
    required this.imagePath,
    required this.pestName,
    required this.highestConfidence,
    required this.pestCount,
    required this.aiRecommendation,
    this.penyuluhRecommendation,
    required this.status,
    required this.detectedAt,
  });
}

class PenyuluhReportDetailResponse {
  final bool success;
  final String? message;
  final PenyuluhReportDetail? data;

  PenyuluhReportDetailResponse({
    required this.success,
    this.message,
    this.data,
  });
}
class NotificationItem {
  final String timestampAgo;
  final String petaniName;
  final String villageName;
  final String detectedPest;
  final String aiConfidence;
  final int? detectionId;

  NotificationItem({
    required this.timestampAgo,
    required this.petaniName,
    required this.villageName,
    required this.detectedPest,
    required this.aiConfidence,
    this.detectionId,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      timestampAgo: json['timestamp_ago']?.toString() ?? '',
      petaniName: json['petani_name']?.toString() ?? '',
      villageName: json['village_name']?.toString() ?? '',
      detectedPest: json['detected_pest']?.toString() ?? '',
      aiConfidence: json['ai_confidence']?.toString() ?? '',
      detectionId: json['detection_id'] != null ? int.tryParse(json['detection_id'].toString()) : json['id'] != null ? int.tryParse(json['id'].toString()) : null,
    );
  }
}

class NotificationsResponse {
  final bool success;
  final String? message;
  final List<NotificationItem> data;

  NotificationsResponse({
    required this.success,
    this.message,
    required this.data,
  });
}

class VillagesResponse {
  final bool success;
  final String? message;
  final List<String> data;

  VillagesResponse({
    required this.success,
    this.message,
    this.data = const [],
  });
}

class PestTrendData {
  final String pestName;
  final int totalDetected;

  PestTrendData({required this.pestName, required this.totalDetected});
}

class PestTrendResponse {
  final bool success;
  final String? message;
  final List<PestTrendData> data;

  PestTrendResponse({
    required this.success,
    this.message,
    this.data = const [],
  });
}

class PenyuluhService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<PenyuluhReportStatusResponse> getReportStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/penyuluh/report-status'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reportData = data['data'] as Map<String, dynamic>? ?? {};
        return PenyuluhReportStatusResponse(
          success: true,
          totalIncoming: reportData['total_incoming'] as int? ?? 0,
          waitingVerification: reportData['waiting_verification'] as int? ?? 0,
          completed: reportData['completed'] as int? ?? 0,
        );
      }
      return PenyuluhReportStatusResponse(success: false, message: 'Failed to fetch status');
    } catch (e) {
      return PenyuluhReportStatusResponse(success: false, message: 'Error: $e');
    }
  }

  static Future<PestTrendResponse> getPestTrend() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/penyuluh/pest-trend'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['data'] as List<dynamic>? ?? [];
        final trends = list.map((item) => PestTrendData(
          pestName: item['pest_name'] ?? '',
          totalDetected: item['total_detected'] as int? ?? 0,
        )).toList();
        return PestTrendResponse(success: true, data: trends);
      }
      return PestTrendResponse(success: false, message: 'Failed to fetch trends');
    } catch (e) {
      return PestTrendResponse(success: false, message: 'Error: $e');
    }
  }

  static Future<VillagesResponse> getVillages() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/penyuluh/villages'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['data'] as List<dynamic>? ?? [];
        final villages = list.map((item) => item.toString()).toList();
        return VillagesResponse(success: true, data: villages);
      }
      return VillagesResponse(success: false, message: 'Failed to fetch villages');
    } catch (e) {
      return VillagesResponse(success: false, message: 'Error: $e');
    }
  }

  static Future<PenyuluhReportResponse> getReports([String type = 'all']) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/penyuluh/detections'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['data'] as List<dynamic>? ?? [];
        
        List<PenyuluhReportItem> reports = list.map((item) => PenyuluhReportItem(
          id: item['id'] as int? ?? 0,
          imagePath: item['image_path']?.toString() ?? '',
          petaniName: item['petani_name']?.toString() ?? '',
          villageName: item['village_name']?.toString() ?? '',
          pestName: item['pest_name']?.toString() ?? '',
          confidence: item['confidence']?.toString() ?? '',
          status: item['status']?.toString() ?? '',
          detectedAt: item['detected_at']?.toString() ?? '',
        )).toList();

        // Filter based on type if API returns all
        if (type == 'pending') {
          reports = reports.where((r) => r.status == 'pending').toList();
        } else if (type == 'completed') {
          reports = reports.where((r) => r.status == 'completed').toList();
        }

        return PenyuluhReportResponse(
          success: true,
          total: data['total'] as int? ?? 0,
          pendingCount: data['pending_count'] as int? ?? 0,
          completedCount: data['completed_count'] as int? ?? 0,
          data: reports,
        );
      }
      return PenyuluhReportResponse(success: false, message: 'Failed to fetch reports');
    } catch (e) {
      return PenyuluhReportResponse(success: false, message: 'Error: $e');
    }
  }

  static Future<PenyuluhReportDetailResponse> getReportDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/penyuluh/detections/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final item = data;
        
        final detail = PenyuluhReportDetail(
          id: item['id'] as int? ?? 0,
          petaniName: item['petani_name']?.toString() ?? '',
          petaniEmail: item['petani_email']?.toString(),
          villageName: item['village_name']?.toString() ?? '',
          description: item['description']?.toString() ?? '',
          imagePath: item['image_path']?.toString() ?? '',
          pestName: item['pest_name']?.toString() ?? '',
          highestConfidence: item['highest_confidence']?.toString() ?? '',
          pestCount: item['pest_count'] as int? ?? 0,
          aiRecommendation: item['ai_recommendation']?.toString() ?? '',
          penyuluhRecommendation: item['penyuluh_recommendation']?.toString(),
          status: item['status']?.toString() ?? '',
          detectedAt: item['detected_at']?.toString() ?? '',
        );

        return PenyuluhReportDetailResponse(success: true, data: detail);
      }
      return PenyuluhReportDetailResponse(success: false, message: 'Failed to load detail');
    } catch (e) {
      return PenyuluhReportDetailResponse(success: false, message: 'Error: $e');
    }
  }

  static Future<bool> submitRecommendation(int id, String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/penyuluh/detections/$id/recommendations'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
        body: jsonEncode({
          'recommendation_text': text,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<NotificationsResponse> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/penyuluh/notifications'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final List list = data['data'] ?? [];
          final items = list.map((e) => NotificationItem.fromJson(e)).toList();
          return NotificationsResponse(success: true, data: items);
        }
      }
      return NotificationsResponse(success: false, message: 'Failed to load notifications', data: []);
    } catch (e) {
      return NotificationsResponse(success: false, message: 'Error: $e', data: []);
    }
  }
}

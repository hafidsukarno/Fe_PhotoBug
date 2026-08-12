import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_photobug/services/auth_service.dart';
import 'package:fe_photobug/services/admin_service.dart';

class ReportService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String reportStatusEndpoint = '$baseUrl/api/petani/report-status';

  // Fetch status laporan dengan filter tanggal
  static Future<ReportStatusResponse> getReportStatus({String? dateFrom, String? dateTo}) async {
    try {
      final List<String> params = [];
      if (dateFrom != null) params.add('date_from=$dateFrom');
      if (dateTo != null) params.add('date_to=$dateTo');
      final queryStr = params.isNotEmpty ? '?${params.join('&')}' : '';

      final response = await http.get(
        Uri.parse('$reportStatusEndpoint$queryStr'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      print('=== REPORT STATUS DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reportData = data['data'] as Map<String, dynamic>? ?? {};

        return ReportStatusResponse(
          success: true,
          totalSent: reportData['total_sent'] as int? ?? 0,
          waitingVerification: reportData['waiting_verification'] as int? ?? 0,
          verified: reportData['verified'] as int? ?? 0,
        );
      } else if (response.statusCode == 401) {
        return ReportStatusResponse(
          success: false,
          message: 'Token expired, silakan login ulang',
        );
      } else {
        return ReportStatusResponse(
          success: false,
          message: 'Gagal mengambil data (${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetching report status: $e');
      return ReportStatusResponse(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  static Future<List<ArticleItem>> getArticles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/articles'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final List list = data['data'] ?? [];
          return list.map((e) => ArticleItem.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getArticles in ReportService: $e');
      return [];
    }
  }
}

class ReportStatusResponse {
  final bool success;
  final String? message;
  final int totalSent;
  final int waitingVerification;
  final int verified;

  ReportStatusResponse({
    required this.success,
    this.message,
    this.totalSent = 0,
    this.waitingVerification = 0,
    this.verified = 0,
  });
}

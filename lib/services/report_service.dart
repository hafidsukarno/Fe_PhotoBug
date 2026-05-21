import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_photobug/services/auth_service.dart';

class ReportService {
  static const String baseUrl = 'http://localhost:8000';
  static const String reportStatusEndpoint = '$baseUrl/api/petani/report-status';

  // Fetch status laporan
  static Future<ReportStatusResponse> getReportStatus() async {
    try {
      final response = await http.get(
        Uri.parse(reportStatusEndpoint),
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

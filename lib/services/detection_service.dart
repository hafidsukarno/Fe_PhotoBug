import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:fe_photobug/services/auth_service.dart';

class DetectionService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String detectionEndpoint = '$baseUrl/api/petani/detections';

  // Submit detection report with image, description, GPS, and rice phase
  static Future<DetectionResponse> submitDetection({
    required Uint8List imageBytes,
    required String fileName,
    String? description,
    double? latitude,
    double? longitude,
    required String ricePhase,
  }) async {
    try {
      print('=== DETECTION SUBMISSION DEBUG ===');
      print('Image File: $fileName');
      print('Description: $description');
      print('GPS: $latitude, $longitude');
      print('Rice Phase: $ricePhase');
      print('Token: ${AuthService.authToken}');

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(detectionEndpoint));
      
      // Add authorization header
      request.headers['Authorization'] = 'Bearer ${AuthService.authToken}';
      request.headers['Accept'] = 'application/json';

      // Add image file from bytes (works on web)
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: fileName,
        ),
      );

      // Add description if provided
      if (description != null && description.isNotEmpty) {
        request.fields['description'] = description;
      }

      if (latitude != null) {
        request.fields['latitude'] = latitude.toString();
      }
      if (longitude != null) {
        request.fields['longitude'] = longitude.toString();
      }
      request.fields['rice_phase'] = ricePhase;

      // Send request
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseString');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(responseString);
        print('\n======== API RESPONSE ========');
        print('Status: ${response.statusCode}');
        print('Detection data: ${jsonResponse['detection']}');
        print('Image path: ${jsonResponse['detection']?['image_path']}');
        print('===============================\n');
        
        final detection = Detection.fromJson(jsonResponse['detection']);
        final penyuluhName = jsonResponse['penyuluh_name'] ?? 'Penyuluh';
        final totalPests = jsonResponse['total_pests'] ?? 0;
        
        print('✅ Detection parsed - Path: ${detection.imagePath}');
        
        return DetectionResponse(
          success: true,
          message: 'Laporan berhasil dikirim',
          statusCode: response.statusCode,
          detection: detection,
          penyuluhName: penyuluhName,
          totalPests: totalPests,
        );
      } else if (response.statusCode == 401) {
        return DetectionResponse(
          success: false,
          message: 'Token expired, silakan login ulang',
          statusCode: response.statusCode,
        );
      } else {
        return DetectionResponse(
          success: false,
          message: 'Gagal mengirim laporan (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('Error submitting detection: $e');
      return DetectionResponse(
        success: false,
        message: 'Error: $e',
        statusCode: 0,
      );
    }
  }

  // Get history of submitted detections
  static Future<HistoryResponse> getHistory(String status, {String? dateFrom, String? dateTo}) async {
    try {
      final List<String> params = [];
      if (status.isNotEmpty && status != 'all') {
        params.add('status=$status');
      }
      if (dateFrom != null) {
        params.add('date_from=$dateFrom');
      }
      if (dateTo != null) {
        params.add('date_to=$dateTo');
      }
      final queryStr = params.isNotEmpty ? '?${params.join('&')}' : '';
      final url = '$baseUrl/api/petani/history$queryStr';
      
      print('Fetching history from: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthService.authToken}',
          'Accept': 'application/json',
        },
      );

      print('History Response Status: ${response.statusCode}');
      print('History Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return HistoryResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        return HistoryResponse(
          success: false,
          message: 'Token expired',
          statusCode: 401,
          total: 0,
          pendingCount: 0,
          completedCount: 0,
        );
      } else {
        return HistoryResponse(
          success: false,
          message: 'Failed to fetch history',
          statusCode: response.statusCode,
          total: 0,
          pendingCount: 0,
          completedCount: 0,
        );
      }
    } catch (e) {
      print('Error fetching history: $e');
      return HistoryResponse(
        success: false,
        message: 'Error: $e',
        statusCode: 0,
        total: 0,
        pendingCount: 0,
        completedCount: 0,
      );
    }
  }  // Get detection detail by ID
  static Future<DetectionResponse> getDetectionDetail(int id) async {
    try {
      final url = '$baseUrl/api/petani/detections/$id';
      
      print('Fetching detection detail from: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthService.authToken}',
          'Accept': 'application/json',
        },
      );

      print('Detail Response Status: ${response.statusCode}');
      // print('Detail Response Body: ${response.body}'); // Commented to avoid console spam

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final detection = Detection.fromJson(jsonResponse['detection']);
        final penyuluhName = jsonResponse['penyuluh_name'] ?? 'Penyuluh';
        final totalPests = jsonResponse['total_pests'] ?? 0;
        
        return DetectionResponse(
          success: true,
          message: 'Success',
          statusCode: response.statusCode,
          detection: detection,
          penyuluhName: penyuluhName,
          totalPests: totalPests,
        );
      } else {
        return DetectionResponse(
          success: false,
          message: 'Failed to fetch detection detail',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('Error fetching detection detail: $e');
      return DetectionResponse(
        success: false,
        message: 'Error: $e',
        statusCode: 0,
      );
    }
  }
}

class DetectionResponse {
  final bool success;
  final String message;
  final int statusCode;
  final Detection? detection;
  final String? penyuluhName;
  final int? totalPests;

  DetectionResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    this.detection,
    this.penyuluhName,
    this.totalPests,
  });
}

class Detection {
  final int id;
  final int userId;
  final String imagePath;
  final String status;
  final String description;
  final DateTime detectedAt;
  final String? villageName;
  final List<DetectionResult> detectionResults;
  final List<Recommendation> recommendations;
  final double? latitude;
  final double? longitude;
  final String? gpsAddress;
  final String? ricePhase;
  final String? hazardLevel;

  Detection({
    required this.id,
    required this.userId,
    required this.imagePath,
    required this.status,
    required this.description,
    required this.detectedAt,
    required this.detectionResults,
    required this.recommendations,
    this.villageName,
    this.latitude,
    this.longitude,
    this.gpsAddress,
    this.ricePhase,
    this.hazardLevel,
  });
  factory Detection.fromJson(Map<String, dynamic> json) {
    String? villageName;
    try {
      villageName = json['user']?['village']?['village_name'] as String?;
    } catch (e) {
      print('Error extracting village name: $e');
    }

    double? lat;
    double? lng;
    if (json['latitude'] != null) {
      lat = double.tryParse(json['latitude'].toString());
    }
    if (json['longitude'] != null) {
      lng = double.tryParse(json['longitude'].toString());
    }

    return Detection(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      imagePath: json['image_path'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      detectedAt: DateTime.tryParse(json['detected_at'] ?? '') ?? DateTime.now(),
      detectionResults: List<DetectionResult>.from(
        (json['detection_results'] as List<dynamic>? ?? [])
            .map((x) => DetectionResult.fromJson(x as Map<String, dynamic>)),
      ),
      recommendations: List<Recommendation>.from(
        (json['recommendations'] as List<dynamic>? ?? [])
            .map((x) => Recommendation.fromJson(x as Map<String, dynamic>)),
      ),
      villageName: villageName,
      latitude: lat,
      longitude: lng,
      gpsAddress: json['gps_address'] as String?,
      ricePhase: json['rice_phase']?.toString(),
      hazardLevel: json['hazard_level']?.toString(),
    );
  }

  // Get the highest confidence detection result
  DetectionResult? getHighestConfidenceResult() {
    if (detectionResults.isEmpty) return null;
    return detectionResults.reduce((a, b) {
      final aConf = double.tryParse(a.confidence) ?? 0;
      final bConf = double.tryParse(b.confidence) ?? 0;
      return aConf > bConf ? a : b;
    });
  }

  // Get average confidence as percentage
  double getAverageConfidence() {
    if (detectionResults.isEmpty) return 0;
    final total = detectionResults.fold<double>(0, (sum, result) {
      return sum + (double.tryParse(result.confidence) ?? 0);
    });
    return (total / detectionResults.length * 100).roundToDouble();
  }
}

class DetectionResult {
  final int id;
  final int detectionId;
  final String pestName;
  final String confidence; // String, needs to be parsed as double

  DetectionResult({
    required this.id,
    required this.detectionId,
    required this.pestName,
    required this.confidence,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      id: json['id'] ?? 0,
      detectionId: json['detection_id'] ?? 0,
      pestName: json['pest_name'] ?? 'Unknown',
      confidence: json['confidence'] ?? '0.0',
    );
  }

  // Get confidence as double (0.0 - 1.0)
  double getConfidenceDouble() {
    return double.tryParse(confidence) ?? 0.0;
  }

  // Get confidence as percentage (0 - 100)
  int getConfidencePercent() {
    return (getConfidenceDouble() * 100).toInt();
  }
}

class Recommendation {
  final int id;
  final int detectionId;
  final String recommendationText;
  final String source;
  final bool isValidated;

  Recommendation({
    required this.id,
    required this.detectionId,
    required this.recommendationText,
    required this.source,
    required this.isValidated,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'] ?? 0,
      detectionId: json['detection_id'] ?? 0,
      recommendationText: json['recommendation_text'] ?? '',
      source: json['source'] ?? '',
      isValidated: (json['is_validated'] ?? 0) == 1,
    );
  }
}

// History Response Models
class HistoryResponse {
  final bool success;
  final String message;
  final int statusCode;
  final int total;
  final int pendingCount;
  final int completedCount;
  final List<HistoryItem>? data;

  HistoryResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.total,
    required this.pendingCount,
    required this.completedCount,
    this.data,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 200,
      total: json['total'] ?? 0,
      pendingCount: json['pending_count'] ?? 0,
      completedCount: json['completed_count'] ?? 0,
      data: json['data'] != null
          ? List<HistoryItem>.from(
              (json['data'] as List).map((x) => HistoryItem.fromJson(x)),
            )
          : null,
    );
  }
}

class HistoryItem {
  final int id;
  final int userId;
  final String imagePath;
  final String villageName;
  final String penyuluhName;
  final String status;
  final DateTime detectedAt;
  final String pestName;
  final String highestConfidence;
  final String recommendation;
  final String aiRecommendation;
  final String penyuluhRecommendation;

  HistoryItem({
    required this.id,
    required this.userId,
    required this.imagePath,
    required this.villageName,
    required this.penyuluhName,
    required this.status,
    required this.detectedAt,
    required this.pestName,
    required this.highestConfidence,
    required this.recommendation,
    this.aiRecommendation = '',
    this.penyuluhRecommendation = '',
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      imagePath: json['image_path'] ?? '',
      villageName: json['village_name'] ?? '',
      penyuluhName: json['penyuluh_name'] ?? '',
      status: json['status'] ?? '',
      detectedAt: DateTime.tryParse(json['detected_at'] ?? '') ?? DateTime.now(),
      pestName: json['pest_name'] ?? 'Unknown',
      highestConfidence: json['highest_confidence'] ?? '0%',
      recommendation: json['recommendation'] ?? json['ai_recommendation'] ?? '',
      aiRecommendation: json['ai_recommendation'] ?? '',
      penyuluhRecommendation: json['penyuluh_recommendation'] ?? '',
    );
  }
}

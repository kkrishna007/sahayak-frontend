import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class AttendanceService {
  static const String baseUrl =
      'https://mcf0c3q9-4000.inc1.devtunnels.ms/api/v1/prabhandhak'; // Replace with your actual backend URL

  /// Process attendance photo by uploading to backend
  static Future<Map<String, dynamic>> processAttendancePhoto({
    required File photoFile,
    required String classId,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/attendance/upload-photo');
      var request = http.MultipartRequest('POST', uri);

      // Get the MIME type of the file
      String? mimeType = lookupMimeType(photoFile.path);
      mimeType ??= 'image/jpeg'; // Default to JPEG if unable to determine

      // Add the photo file with explicit content type
      var multipartFile = await http.MultipartFile.fromPath(
        'photo',
        photoFile.path,
        filename: 'attendance_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType('image', 'jpeg'),
      );

      request.files.add(multipartFile);
      request.fields['class_id'] = classId;

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
      });

      print('Uploading file: ${photoFile.path}');
      print('MIME type: $mimeType');
      print('File size: ${await photoFile.length()} bytes');

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to process attendance: ${response.body}');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error uploading photo: $e');
    }
  }

  /// Get attendance records for a class
  static Future<List<AttendanceRecord>> getAttendanceRecords({
    required String classId,
    DateTime? date,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/attendance/records');
      var queryParams = {'class_id': classId};

      if (date != null) {
        queryParams['date'] = date.toIso8601String().split('T')[0];
      }

      uri = uri.replace(queryParameters: queryParams);

      var response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return (data['records'] as List)
            .map((record) => AttendanceRecord.fromJson(record))
            .toList();
      } else {
        throw Exception('Failed to fetch attendance records: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching attendance records: $e');
    }
  }

  /// Submit manual attendance corrections
  static Future<bool> submitAttendanceCorrections({
    required String classId,
    required List<AttendanceRecord> corrections,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/attendance/corrections');

      var body = json.encode({
        'class_id': classId,
        'corrections': corrections.map((record) => record.toJson()).toList(),
      });

      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error submitting corrections: $e');
    }
  }
}

class AttendanceRecord {
  final String studentId;
  final String studentName;
  final String status; // 'present', 'absent', 'late'
  final DateTime timestamp;
  final double? confidence; // AI confidence score

  AttendanceRecord({
    required this.studentId,
    required this.studentName,
    required this.status,
    required this.timestamp,
    this.confidence,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      studentId: json['student_id'],
      studentName: json['student_name'],
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
      confidence: json['confidence']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'confidence': confidence,
    };
  }

  AttendanceRecord copyWith({
    String? studentId,
    String? studentName,
    String? status,
    DateTime? timestamp,
    double? confidence,
  }) {
    return AttendanceRecord(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      confidence: confidence ?? this.confidence,
    );
  }
}

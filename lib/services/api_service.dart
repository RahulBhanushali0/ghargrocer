// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/appConstants.dart';

class ApiService {
  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final url = Uri.parse(AppConstants.baseUrl + AppConstants.sendOtpEndpoint);
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': AppConstants.authToken.toString(),
        },
        body: {
          'phone': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Handle error responses appropriately
        print('Error sending OTP: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {'success': false, 'message': 'Failed to send OTP. Status code: ${response.statusCode}'};
      }
    } catch (e) {
      print('Exception sending OTP: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    final url = Uri.parse(AppConstants.baseUrl + AppConstants.verifyOtpEndpoint);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': AppConstants.authToken.toString(),
        },
        body: {
          'phone': phoneNumber,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Handle error responses appropriately
        print('Error verifying OTP: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {'success': false, 'message': 'Failed to verify OTP. Status code: ${response.statusCode}'};
      }
    } catch (e) {
      print('Exception verifying OTP: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}

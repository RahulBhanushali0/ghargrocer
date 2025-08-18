// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holmon/services/api_service.dart';

import '../services/secure_storage_service.dart';
import '../views/otp_verification_screen.dart'; // Adjust import path

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final SecureStorageService _secureStorageService =
      SecureStorageService(); // Instantiate it

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  var isLoading = false.obs;
  var phoneNumber = ''.obs; // To store the phone number across screens
  var apiToken = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadApiToken(); // Load token when controller initializes
  }

  Future<void> loadApiToken() async {
    apiToken.value = await _secureStorageService.getApiToken();
    print("asdasdasd  ${apiToken.value}");
  }

  // Method to send OTP
  Future<void> sendOtp() async {
    if (phoneController.text.isEmpty || phoneController.text.length != 10) {
      Get.snackbar('Error', 'Please enter a valid 10-digit mobile number.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    phoneNumber.value = phoneController.text; // Store the phone number

    try {
      final response = await _apiService.sendOtp(phoneNumber.value);
      isLoading.value = false;

      // Assuming your API returns a 'success' field or similar
      if (response['success'] == true || response['status'] == 'success') {
        // Adjust based on your API response
        print(response);
        Get.to(() => OtpVerificationScreen());
        Get.snackbar('Success', 'OTP sent to ${phoneNumber.value}',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', response['message'] ?? 'Failed to send OTP',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Method to verify OTP
  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty || otpController.text.length < 4) {
      Get.snackbar('Error', 'Please enter a valid OTP.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final response =
          await _apiService.verifyOtp(phoneNumber.value, otpController.text);
      isLoading.value = false;

      final isOk =
          (response['success'] == true) || (response['status'] == 'success');
      final token = response['data']?['token'] ?? response['token'];
      if (isOk && token != null && token.toString().isNotEmpty) {
        await _secureStorageService.saveApiToken(token.toString());
        apiToken.value = token.toString();
        Get.offAllNamed('/dashboard');
        Get.snackbar('Success', 'Login Successful!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error',
            response['message'] ?? 'Invalid OTP or verification failed.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> logout() async {
    await _secureStorageService.deleteApiToken();
    apiToken.value = null;
    // Navigate to login screen or perform other cleanup
    Get.offAllNamed('/registration');
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}

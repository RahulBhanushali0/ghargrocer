// lib/views/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:holmon/controllers/auth_controller.dart'; // Import AuthController
import 'package:holmon/views/common_widgets/appBar.dart'; // Adjust import if needed
import 'package:holmon/constants/assets.dart'; // Adjust import if needed


class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>(); // Find existing controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: MyAppBar(
          title: Text("Verify OTP"),
          leading:
          InkResponse(onTap: () => Get.back(), child: BackButtonIcon())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar( // Optional: Add app icon or relevant image
                    backgroundColor: Get.theme.cardColor,
                    radius: 36,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        Assets.imagesAppIcon, // Make sure this asset exists
                        scale: 4.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Enter OTP",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Obx(() => Text( // Show phone number from controller
                    "OTP sent to +91 ${authController.phoneNumber.value}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Get.theme.colorScheme.primary),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                      controller: authController.otpController, // Use controller
                      textAlign: TextAlign.center,
                      maxLength: 6, // Adjust OTP length if needed
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 10, // For better OTP appearance
                        fontWeight: FontWeight.bold,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        constraints: BoxConstraints.loose(Size.fromHeight(80)),
                        border: InputBorder.none,
                        hintText: "------",
                        hintStyle: TextStyle(
                            fontSize: 20,
                            letterSpacing: 10,
                            color: Get.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => FractionallySizedBox(
                    widthFactor: 1,
                    child: ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : () {
                          authController.verifyOtp();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                          shape: StadiumBorder(),
                          backgroundColor: Get.theme.primaryColor,
                        ),
                        child: authController.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Verify & Proceed",
                          style: TextStyle(color: Colors.white),
                        )),
                  )),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Optionally allow resending OTP
                      // You might want to add a cooldown for this
                      authController.otpController.clear(); // Clear OTP field
                      authController.sendOtp(); // Resend OTP
                    },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Add some bottom padding
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

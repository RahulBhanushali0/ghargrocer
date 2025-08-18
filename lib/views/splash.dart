import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holmon/constants/assets.dart';
import 'package:holmon/views/welcome.dart';

import '../services/secure_storage_service.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatusAndNavigate();
  }

  Future<void> _checkLoginStatusAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final SecureStorageService secureStorageService = SecureStorageService();
    final String? apiToken = await secureStorageService.getApiToken();

    final String targetRoute = apiToken != null && apiToken.isNotEmpty
        ? '/dashboard'
        : '/';

    Get.offAllNamed(targetRoute);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(
        child: Image.asset(
          Assets.imagesAppIcon,
          scale: 2.5,
        ),
      ),
    );
  }
}

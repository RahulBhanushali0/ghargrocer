// lib/services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  final String _apiTokenKey = 'api_token'; // Key to store the token

  Future<void> saveApiToken(String token) async {
    await _storage.write(key: _apiTokenKey, value: token);
  }

  Future<String?> getApiToken() async {
    return await _storage.read(key: _apiTokenKey);
  }

  Future<void> deleteApiToken() async {
    await _storage.delete(key: _apiTokenKey);
  }
}
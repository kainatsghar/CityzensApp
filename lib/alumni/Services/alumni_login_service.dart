import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcs_app/alumni/Constants/alumni_constants.dart';
import 'package:tcs_app/alumni/Model/alumni_user_model.dart';
import 'package:tcs_app/Utils/app_constants.dart';

class AlumniLoginService {
  /// Performs Alumni user login against the TCS Alumni backend API
  static Future<AlumniLoginResponse> loginRequest({
    required String email,
    required String password,
  }) async {
    try {
      final platform = kIsWeb
          ? 'web'
          : Platform.isIOS
              ? 'ios'
              : 'android';

      final Map<String, String> fields = {
        'email': email.trim(),
        'password': password,
        'login_with': 'email',
        'platform': platform,
        'app_version': AppConstants.appVersion,
        'latitude': '',
        'longitude': '',
        'device_manufacturer': '',
        'device_model': '',
        'device_version': '',
        'device_token': '',
        'device_uuid': '',
        'device_status': 'A',
      };

      final uri = Uri.parse(
        '${AlumniConstants.baseUrl}${AlumniConstants.loginEndpoint}',
      );
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Accept': 'application/json',
      });
      request.fields.addAll(fields);

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 40),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please try again.');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);
      debugPrint('Alumni Login Status: ${response.statusCode}');
      debugPrint('Alumni Login Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final result = AlumniLoginResponse.fromJson(decoded);

          if (result.isSuccessful && result.user != null) {
            await _saveAlumniSession(result.user!, password);
          }
          return result;
        }
      }

      // If status code is non-200 or unexpected format
      try {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return AlumniLoginResponse.fromJson(decoded);
        }
      } catch (_) {}

      return AlumniLoginResponse(
        success: 0,
        message: 'Login failed. Please check your credentials.',
      );
    } on SocketException {
      return AlumniLoginResponse(
        success: 0,
        message: 'No internet connection. Please check your network.',
      );
    } on TimeoutException catch (e) {
      return AlumniLoginResponse(
        success: 0,
        message: e.message ?? 'Connection timed out.',
      );
    } catch (e) {
      return AlumniLoginResponse(
        success: 0,
        message: 'An error occurred during Alumni login: $e',
      );
    }
  }

  /// Saves the Alumni session into SharedPreferences
  static Future<void> _saveAlumniSession(
    AlumniUserModel user,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AlumniConstants.keyIsAlumniLoggedIn, true);
    await prefs.setString(AlumniConstants.keyAlumniLoginStatus, '1');
    await prefs.setString(
      AlumniConstants.keyAlumniUserData,
      jsonEncode(user.toJson()),
    );

    if (user.token != null && user.token!.isNotEmpty) {
      await prefs.setString(AlumniConstants.keyAlumniToken, user.token!);
    }
    if (user.userId != null) {
      await prefs.setString(AlumniConstants.keyAlumniUserId, user.userId!);
    }
    if (user.email != null) {
      await prefs.setString('email', user.email!);
    }
    if (user.firstName != null) {
      await prefs.setString('firstName', user.firstName!);
    }
    if (user.lastName != null) {
      await prefs.setString('lastName', user.lastName!);
    }
    if (user.branchName != null) {
      await prefs.setString('branchName', user.branchName!);
    }
    if (user.image != null) {
      await prefs.setString('userImage', user.image!);
    }
  }

  /// Checks whether an Alumni user is currently logged in
  static Future<bool> isAlumniLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isAlumni =
        prefs.getBool(AlumniConstants.keyIsAlumniLoggedIn) ?? false;
    final String? loginStatus =
        prefs.getString(AlumniConstants.keyAlumniLoginStatus);
    final String? token = prefs.getString(AlumniConstants.keyAlumniToken);

    return isAlumni ||
        (loginStatus == '1' && token != null && token.isNotEmpty);
  }

  /// Retrieves the currently stored Alumni user data
  static Future<AlumniUserModel?> getStoredAlumniUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(AlumniConstants.keyAlumniUserData);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(userJson);
        if (decoded is Map<String, dynamic>) {
          return AlumniUserModel.fromJson(decoded);
        }
      } catch (e) {
        debugPrint('Error decoding alumni user data: $e');
      }
    }
    return null;
  }

  /// Logs out the Alumni user
  static Future<void> logoutAlumni() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AlumniConstants.keyIsAlumniLoggedIn);
    await prefs.remove(AlumniConstants.keyAlumniLoginStatus);
    await prefs.remove(AlumniConstants.keyAlumniUserData);
    await prefs.remove(AlumniConstants.keyAlumniToken);
    await prefs.remove(AlumniConstants.keyAlumniUserId);
    await prefs.remove('email');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('branchName');
    await prefs.remove('userImage');
  }
}

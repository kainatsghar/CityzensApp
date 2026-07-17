import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tcs_app/utils/app_constants.dart';
import 'app_exceptions.dart';

class ApiBaseHelper {
  static Future<Map<String, dynamic>> httpGetRequest(String endPoint) async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse('${AppConstants.apiBaseURL}$endPoint'),
        headers: AppConstants.appHeaders,
      );
    } on SocketException {
      throw FetchDataException(AppConstants.noInternetMsg);
    } on FormatException {
      throw FetchDataException(AppConstants.badResponseFormat);
    } on TimeoutException {
      throw FetchDataException(AppConstants.slowInternetMsg);
    } catch (_) {
      throw FetchDataException(AppConstants.exceptionMessage);
    }
    return _returnResponse(response);
  }

  static Future<Map<String, dynamic>> httpPostRequest(
    String endPoint, {
    Object? body,
    String? token,
  }) async {
    http.Response response;

    final headers = {'Authorization': 'Bearer $token'};
    headers.addAll(AppConstants.appHeaders);

    try {
      if (kDebugMode) {
        log('Request URL: ${AppConstants.apiBaseURL}$endPoint');
        log('Request Headers: $headers');
        log('Request Body: ${json.encode(body)}');
      }

      response = await http.post(
        Uri.parse('${AppConstants.apiBaseURL}$endPoint'),
        headers: AppConstants.appHeaders,
        body: json.encode(body),
      );
    } on SocketException {
      throw FetchDataException(AppConstants.noInternetMsg);
    } on FormatException {
      throw FetchDataException(AppConstants.badResponseFormat);
    } on TimeoutException {
      throw FetchDataException(AppConstants.slowInternetMsg);
    } catch (e) {
      if (kDebugMode) {
        log('Error: ${e.toString()}');
      }
      throw FetchDataException(AppConstants.exceptionMessage);
    }
    return _returnResponse(response);
  }

  static Future<Map<String, dynamic>> httpPutRequest(
    String endPoint, {
    Object? body,
  }) async {
    http.Response response;
    try {
      response = await http.put(
        Uri.parse('${AppConstants.apiBaseURL}$endPoint'),
        headers: AppConstants.appHeaders,
        body: jsonEncode(body),
      );
    } on SocketException {
      throw FetchDataException(AppConstants.noInternetMsg);
    } on FormatException {
      throw FetchDataException(AppConstants.badResponseFormat);
    } on TimeoutException {
      throw FetchDataException(AppConstants.slowInternetMsg);
    } catch (_) {
      throw FetchDataException(AppConstants.exceptionMessage);
    }
    return _returnResponse(response);
  }

  static Future<Map<String, dynamic>> httpPatchRequest(
    String endPoint,
    Object body,
  ) async {
    http.Response response;
    try {
      response = await http.patch(
        Uri.parse('${AppConstants.apiBaseURL}$endPoint'),
        body: jsonEncode(body),
        headers: AppConstants.appHeaders,
      );
    } on SocketException {
      throw FetchDataException(AppConstants.noInternetMsg);
    } on FormatException {
      throw FetchDataException(AppConstants.badResponseFormat);
    } on TimeoutException {
      throw FetchDataException(AppConstants.slowInternetMsg);
    } catch (_) {
      throw FetchDataException(AppConstants.exceptionMessage);
    }
    return _returnResponse(response);
  }

  static Future<Map<String, dynamic>> httpDeleteRequest(
    String endPoint, {
    Object? body,
  }) async {
    http.Response response;
    try {
      response = await http.delete(
        Uri.parse('${AppConstants.apiBaseURL}$endPoint'),
        headers: AppConstants.appHeaders,
      );
    } on SocketException {
      throw FetchDataException(AppConstants.noInternetMsg);
    } on FormatException {
      throw FetchDataException(AppConstants.badResponseFormat);
    } on TimeoutException {
      throw FetchDataException(AppConstants.slowInternetMsg);
    } catch (_) {
      throw FetchDataException(AppConstants.exceptionMessage);
    }
    return _returnResponse(response);
  }

  static Future<Map<String, dynamic>> httpMultipartPostRequest(
    String endPoint, {
    required Map<String, String> fields,
    required String filePath,
    String fileField = 'file',
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.apiBaseURL}$endPoint');
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(
        AppConstants.appHeaders.map((key, value) => MapEntry(key, value)),
      );
      request.fields.addAll(fields);
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));

      if (kDebugMode) {
        log('Multipart Request URL: $uri');
        log('Multipart Fields: $fields');
        log('Multipart File: $filePath');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException(AppConstants.noInternetMsg);
    } on FormatException {
      throw FetchDataException(AppConstants.badResponseFormat);
    } on TimeoutException {
      throw FetchDataException(AppConstants.slowInternetMsg);
    } catch (e) {
      if (kDebugMode) log('Multipart Error: ${e.toString()}');
      throw FetchDataException(AppConstants.exceptionMessage);
    }
  }
}

Map<String, dynamic> _returnResponse(http.Response response) {
  if (kDebugMode) {
    log('Response URL: ${response.request?.url}\n${response.body}');
  }

  Map<String, dynamic> jsonResponse = {};
  if (response.body.isNotEmpty) {
    try {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        jsonResponse = decoded;
      } else {
        // If the API returns a List or primitive, wrap it in a map to prevent TypeErrors
        jsonResponse = {'data': decoded};
      }
    } catch (e) {
      if (kDebugMode) {
        log('Failed to decode JSON: $e');
      }
    }
  }

  // Any 2xx status code is a success (e.g. 200 OK, 201 Created, 204 No Content)
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return jsonResponse;
  }

  switch (response.statusCode) {
    case 400:
      throw BadRequestException(
        jsonResponse['message'] ??
            jsonResponse['Message'] ??
            AppConstants.exceptionMessage,
      );
    case 401:
      throw InvalidInputException(
        jsonResponse['message'] ??
            jsonResponse['Message'] ??
            AppConstants.exceptionMessage,
      );
    case 403:
      throw UnAuthorizedException(
        jsonResponse['message'] ??
            jsonResponse['Message'] ??
            AppConstants.exceptionMessage,
      );
    case 404:
      throw FetchDataException(
        jsonResponse['message'] ??
            jsonResponse['Message'] ??
            AppConstants.exceptionMessage,
      );
    case 500:
    default:
      throw FetchDataException(
        jsonResponse['message'] ??
            jsonResponse['Message'] ??
            AppConstants.exceptionMessage,
      );
  }
}

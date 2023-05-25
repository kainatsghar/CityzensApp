import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tcs_app/Utils/app_constants.dart';
import 'app_exceptions.dart';

class ApiBaseHelper {
  static Future<Map<String, dynamic>> httpGetRequest(String endPoint,
      {String base = AppConstants.apiBaseURL}) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse('$base$endPoint'),
          headers: AppConstants.appHeaders);
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

  static Future<Map<String, dynamic>> httpPostRequest(String endPoint,
      {Object body, String base = AppConstants.apiBaseURL}) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse('$base$endPoint'),
          headers: AppConstants.appHeaders, body: json.encode(body));
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

  static Future<Map<String, dynamic>> httpPutRequest(String endPoint,
      {Object body, String base = AppConstants.apiBaseURL}) async {
    http.Response response;
    try {
      response = await http.put(Uri.parse('$base$endPoint'),
          headers: AppConstants.appHeaders, body: jsonEncode(body));
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
      String endPoint, Object body) async {
    http.Response response;
    try {
      response = await http.patch(
          Uri.parse('${AppConstants.apiBaseURL}$endPoint'),
          body: jsonEncode(body),
          headers: AppConstants.appHeaders);
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

  static Future<Map<String, dynamic>> httpDeleteRequest(String endPoint,
      {Object body}) async {
    http.Response response;
    try {
      response = await http.delete(
          Uri.parse('${AppConstants.apiBaseURL}$endPoint'),
          headers: AppConstants.appHeaders);
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
}

Map<String, dynamic> _returnResponse(http.Response response) {
  final jsonResponse = jsonDecode(response.body);
  switch (response.statusCode) {
    case 200:
      return jsonResponse;
    case 400:
      throw BadRequestException(
          jsonResponse['message'] ?? AppConstants.exceptionMessage);
    case 401:
      throw InvalidInputException(
          jsonResponse['message'] ?? AppConstants.exceptionMessage);
    case 403:
      throw UnauthorisedException(
          jsonResponse['message'] ?? AppConstants.exceptionMessage);
    case 404:
      throw FetchDataException(
          jsonResponse['message'] ?? AppConstants.exceptionMessage);
    case 500:
    default:
      throw FetchDataException(
          jsonResponse['message'] ?? AppConstants.exceptionMessage);
  }
}

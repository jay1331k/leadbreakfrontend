import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_endpoints.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(FirebaseAuth.instance);
});

class ApiClient {
  final FirebaseAuth _firebaseAuth;
  final http.Client _httpClient;

  ApiClient(this._firebaseAuth) : _httpClient = http.Client();

  Future<Map<String, String>> get _headers async {
    final token = await _firebaseAuth.currentUser?.getIdToken();
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  Future<http.Response> get(String path, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
    final uriWithQuery = queryParams != null 
        ? uri.replace(queryParameters: queryParams)
        : uri;
    
    try {
      final response = await _httpClient.get(
        uriWithQuery,
        headers: await _headers,
      );
      _logResponse('GET', path, response);
      return response;
    } catch (e) {
      _logError('GET', path, e);
      rethrow;
    }
  }

  Future<http.Response> post(String path, {dynamic body}) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
    
    try {
      final response = await _httpClient.post(
        uri,
        headers: await _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse('POST', path, response);
      return response;
    } catch (e) {
      _logError('POST', path, e);
      rethrow;
    }
  }

  Future<http.Response> put(String path, {dynamic body}) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
    
    try {
      final response = await _httpClient.put(
        uri,
        headers: await _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse('PUT', path, response);
      return response;
    } catch (e) {
      _logError('PUT', path, e);
      rethrow;
    }
  }

  Future<http.Response> delete(String path) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}$path');
    
    try {
      final response = await _httpClient.delete(
        uri,
        headers: await _headers,
      );
      _logResponse('DELETE', path, response);
      return response;
    } catch (e) {
      _logError('DELETE', path, e);
      rethrow;
    }
  }

  void _logResponse(String method, String path, http.Response response) {
    print('[$method] $path -> ${response.statusCode}');
    if (response.statusCode >= 400) {
      print('Error response: ${response.body}');
    }
  }

  void _logError(String method, String path, dynamic error) {
    print('[$method] $path -> ERROR: $error');
  }

  void dispose() {
    _httpClient.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? details;

  const ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}

// Helper functions for handling API responses
T handleApiResponse<T>(
  http.Response response,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (response.statusCode >= 200 && response.statusCode < 300) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return fromJson(data);
  } else {
    throw ApiException(
      'Request failed',
      statusCode: response.statusCode,
      details: response.body,
    );
  }
}

List<T> handleApiListResponse<T>(
  http.Response response,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (response.statusCode >= 200 && response.statusCode < 300) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .cast<Map<String, dynamic>>()
        .map((item) => fromJson(item))
        .toList();
  } else {
    throw ApiException(
      'Request failed',
      statusCode: response.statusCode,
      details: response.body,
    );
  }
}

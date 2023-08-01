import 'package:dio/dio.dart';
import 'package:test_flutter/data/SharedPreferencesHelper.dart';
import 'package:test_flutter/data/models/api_response.dart';
import 'package:test_flutter/presentation/utils/utils.dart';

import '../../presentation/constants/constants.dart';

class RestClient {
  static final RestClient _instance = RestClient._internal();
  final Dio _dio;

  factory RestClient() {
    return _instance;
  }

  RestClient._internal() : _dio = Dio() {
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        options.connectTimeout = const Duration(seconds: 6);
        options.receiveTimeout = const Duration(seconds: 6);
        options.sendTimeout = const Duration(seconds: 6);

        final queryParams = options.queryParameters;
        final headers = options.headers;
        final body = options.data;
        headers['Content-Type'] = "application/json";
        headers['device'] = Utils().getDeviceId();
        headers['platform'] = Utils().getPlatformName();
        SharedPreferencesHelper.init();
        headers['Authorization'] =
        "Bearer ${SharedPreferencesHelper.getDummyToken()}";
        print('Request URl: ${options.method} ${options.uri}');
        print('Request Body: $body');
        if (queryParams != null && queryParams.isNotEmpty) {
          print('Parameters: $queryParams');
        }
        return handler.next(options);
      }, onResponse: (response, handler) {
        print("StatusCode : ${response.statusCode}");
        if (response.statusCode == 200) {
          print("Response body : ${response.data}");
          return handler.resolve(response);
        } else {
          print("Response status code: ${response.statusCode}");
          print("Response body : ${response.data}");
          final errorResponse = Response(
            statusCode: response.statusCode,
            data: response.data,
            requestOptions: response.requestOptions,
            headers: response.headers,
            isRedirect: response.isRedirect,
            redirects: response.redirects,
            statusMessage: response.statusMessage,
          );
          return handler.reject(DioException(
            requestOptions: RequestOptions(),
            response: errorResponse,
            error: "Request failed with status code ${response.statusCode}",
          ));
        }
      }),
    );
  }

  String _constructUrl(String endpoint,
      {Map<String, dynamic>? queryParameters}) {
    String url = BASE_URL + endpoint;
    if (queryParameters != null && queryParameters.isNotEmpty) {
      url += '?';
      url += Uri(queryParameters: queryParameters).query;
    }
    return url;
  }

  Future<ApiResponse<T>> postRequest<T>({
    required String endpoint,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.post(_constructUrl(endpoint), data: data);
      return handleResponse<T>(response, fromJson);
    } catch (error) {
      return handleErrorResponse<T>(error);
    }
  }

  Future<ApiResponse<T>> putRequest<T>({
    required String endpoint,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(_constructUrl(endpoint),
          data: data, queryParameters: queryParameters);
      return handleResponse<T>(response, fromJson);
    } catch (error) {
      return handleErrorResponse<T>(error);
    }
  }

  Future<ApiResponse<T>> deleteRequest<T>({
    required String endpoint,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(_constructUrl(endpoint),
          data: data, queryParameters: queryParameters);
      return handleResponse<T>(response, fromJson);
    } catch (error) {
      return handleErrorResponse<T>(error);
    }
  }

  Future<ApiResponse<T>> getRequest<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(_constructUrl(endpoint),
          queryParameters: queryParameters);
      return handleResponse<T>(response, fromJson);
    } catch (error) {
      return handleErrorResponse<T>(error);
    }
  }

  Future<Response> uploadFileWithProgress(String filePath,
      String endpoint,
      Function(int sentBytes, int totalBytes) progressCallback,) async {
    final url = _constructUrl(endpoint);

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    final response = await _dio.post(
      url,
      data: formData,
      onSendProgress: (sentBytes, totalBytes) {
        progressCallback(sentBytes, totalBytes);
      },
    );

    return response;
  }
}

ApiResponse<T> handleResponse<T>(Response<dynamic> response,
    T Function(Map<String, dynamic>) fromJson,) {
  if (response.statusCode == 200) {
    return ApiResponse<T>(
      data: fromJson(response.data),
      result: true,
      msg: "success",
      isNextLink: true,
    );
  } else {
    return ApiResponse<T>(
      result: false,
      data: response.data as T,
      msg: "Request failed with status code ${response.statusCode}",
      statusCode: response.statusCode,
    );
  }
}

ApiResponse<T> handleErrorResponse<T>(dynamic error) {
  if (error is DioException && error.response != null) {
    print(error.response);
    return ApiResponse<T>(
      result: false,
      data: null,
      msg: "${error.response!.statusCode}/${error.response!.data['message']}",
      statusCode: error.response!.statusCode!,
      responseData: error.response!.data,
    );
  } else {
    return ApiResponse<T>(
      result: false,
      msg: "Error occurred",
      data: null,
    );
  }
}}

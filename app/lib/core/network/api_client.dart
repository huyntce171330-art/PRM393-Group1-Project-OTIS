import 'package:dio/dio.dart';
import 'package:frontend_otis/core/constants/api_constants.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 3),
            ),
          );

  Future<Response> get(String path) => _dio.get(path);
  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);
  Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);
  Future<Response> delete(String path) => _dio.delete(path);
}

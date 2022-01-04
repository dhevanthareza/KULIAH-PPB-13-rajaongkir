import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rajaongkir/config.dart';
import 'package:rajaongkir/model/app_exception.dart';

class Request {
  // ignore: top_level_function_literal_block, prefer_function_declarations_over_variables
  static final client = () async {
    var dio = Dio(
      BaseOptions(
        followRedirects: true,
        headers: {"Accept": "application/json", "key": AppConfig.apiKey},
        connectTimeout: 30000,
        receiveTimeout: 30000,
        baseUrl: AppConfig.gateway,
      ),
    );
    return dio;
  };
  static dynamic _returnResponse(Response? response) {
    if (response == null) {
      throw AppException(message: 'Tidak dapat terkoneksi dengan API');
    }
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data;
        return responseJson;
      case 201:
        var responseJson = response.data;
        return responseJson;
      default:
        throw AppException(message: 'Terjadi Error');
    }
  }

  static dynamic _returnErr(DioError err) {
    print("=======API ERROR====");
    print(err);
    var response = err.response;
    if (response == null) {
      throw AppException(message: err.message);
    }
    print(err.response);
    print("===============RESPONSE DATA====================");
    print(err.response!.data);
    if (err.response!.data['error'] == null) {
      throw AppException(
          message: response.data['error']['message'] ?? 'Undefined Error 500');
    }
    return _returnResponse(err.response);
  }

  static Future<dynamic> get(String url,
      {Map<String, dynamic>? queryParameter}) async {
    dynamic responseJson;
    try {
      Dio _client = await client();
      dynamic response =
          await _client.get(url, queryParameters: queryParameter);
      responseJson = _returnResponse(response);
    } on SocketException catch (err) {
      throw AppException(message: 'No Internet connection');
    } on DioError catch (err) {
      responseJson = _returnResponse(err.response);
    }
    return responseJson;
  }

  static Future<dynamic> post(String url, {dynamic data}) async {
    dynamic responseJson;
    Response response;
    try {
      Dio _client = await client();
      response = await _client.post(url, data: data);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw AppException(message: 'No Internet connection');
    } on DioError catch (err) {
      responseJson = _returnErr(err);
    }
    return responseJson;
  }
}

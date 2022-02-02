import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TokenInterceptor extends Interceptor {
  Dio dio;

  TokenInterceptor({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? token = await user?.getIdToken();
    dio.interceptors.requestLock.lock();
    if (user != null) options.headers[HttpHeaders.authorizationHeader] = token;
    dio.interceptors.requestLock.unlock();
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Sends response ahead for code 200 to 204
    // sends [DioError] for anything else
    if (response.statusCode! >= 200 && response.statusCode! <= 204) {
      return handler.next(response);
    } else if (response.statusCode == 401) {
      return handler.reject(DioError(
          requestOptions: RequestOptions(path: response.requestOptions.path), error: response.data['message']));
    } else {
      handler.reject(DioError(requestOptions: response.requestOptions));
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // change message for socket exception
    if (err.message.contains("SocketException")) {
      return handler.next(
        DioError(requestOptions: err.requestOptions, error: "Oops! looks like you are not connected to internet"),
      );
    }
    print(err);
    return handler.reject(DioError(requestOptions: err.requestOptions, error: err.response?.data));
  }
}

import 'package:delivery/common/const/data.dart';
import 'package:delivery/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(CustomInterceptor(storage: storage));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'ture') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: accessTokenKey);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'ture') {
      options.headers.remove('refreshToken');
      final token = await storage.read(key: refreshTokenKey);
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: refreshTokenKey);

    if (refreshToken == null) {
      // 에러를 던지는 방법
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );

        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;
        options.headers.addAll({'authorization': 'Bearer $accessToken'});

        await storage.write(key: accessTokenKey, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioError catch (e) {
        // refreshToken이 만료됬을 때 에러 발생
        // userMeProvider를 사용하면 순환참조 발생 (userMeProvider에서 dio를 사용하는
        return handler.reject(e);
      }
    }
    return handler.reject(err);
  }
}

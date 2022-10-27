import 'package:delivery/common/const/data.dart';
import 'package:delivery/common/dio/dio.dart';
import 'package:delivery/common/model/login_response.dart';
import 'package:delivery/common/model/token_response.dart';
import 'package:delivery/common/utils/data_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final baseUrl = 'http://$ip/auth';
  final dio = ref.watch(dioProvider);
  return AuthRepository(baseUrl: baseUrl, dio: dio);
})

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  const AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final serialized = DataUtils.plainToBase64('$username:$password');

    final response = await dio.post(
      '$baseUrl/login',
      options: Options(headers: {'authorization': 'Basic $serialized'}),
    );

    return LoginResponse.fromJson(response.data);
  }

  Future<TokenResponse> token() async {
    final response = await dio.post(
      '$baseUrl/token',
      options: Options(
        headers: {'refreshToken': 'true'},
      ),
    );

    return TokenResponse.fromJson(response.data);
  }
}

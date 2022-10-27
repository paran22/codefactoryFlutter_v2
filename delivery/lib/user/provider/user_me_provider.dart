import 'package:delivery/common/const/data.dart';
import 'package:delivery/common/secure_storage/secure_storage.dart';
import 'package:delivery/user/model/user_model.dart';
import 'package:delivery/user/provider/auth_provider.dart';
import 'package:delivery/user/repository/auth_repository.dart';
import 'package:delivery/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final repository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return UserMeStateNotifier(
    authRepository: authRepository,
    repository: repository,
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: refreshTokenKey);
    final accessToken = await storage.read(key: accessTokenKey);

    if (refreshToken == null || accessToken == null) {
      state == null;
      return;
    }

    state = await repository.getMe();
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();
      final response =
          await authRepository.login(username: username, password: password);

      await storage.write(
        key: refreshTokenKey,
        value: response.refreshToken,
      );
      await storage.write(
        key: accessTokenKey,
        value: response.accessToken,
      );

      final userResponse = await repository.getMe();

      state = userResponse;

      return userResponse;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait([
      storage.delete(key: refreshTokenKey),
      storage.delete(key: accessTokenKey),
    ]);
  }
}

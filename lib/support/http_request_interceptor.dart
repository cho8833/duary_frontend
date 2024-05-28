import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:duary/data/authorization_token_res.dart';
import 'package:duary/provider/auth_provider.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/auth_repository.dart';
import 'package:duary/repository/secure_storage.dart';
import 'package:duary/support/custom_exception.dart';

class TokenInterceptor implements InterceptorContract {
  final SecureStorage secureStorage;
  final TokenProvider tokenProvider = TokenProvider();
  final AuthProvider authProvider = AuthProvider();
  late final AuthRepository _authRepository;

  String? accessToken;

  TokenInterceptor(this.secureStorage);

  set authRepository(AuthRepository repository) {
    _authRepository = repository;
  }

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String? accessToken = await tokenProvider.accessToken;
    if (accessToken == null || checkJwtExpired(accessToken)) {
      String? refreshToken = await tokenProvider.refreshToken;
      if (refreshToken == null || checkJwtExpired(refreshToken)) {
        authProvider.isLoggedIn.value = false;
        throw ForbiddenException();
      }
      AuthorizationTokenRes res =
      await _authRepository.reissue(accessToken ?? "", refreshToken);
      accessToken = res.accessToken;
      await tokenProvider.storeAccessToken(res.accessToken);
      await tokenProvider.storeRefreshToken(res.refreshToken);
    }
    data.headers['Content-Type'] = 'application/json';
    data.headers['Authorization'] = 'Bearer $accessToken';

    return data;
  }

  bool checkJwtExpired(String accessToken) {
    JWT? jwt = JWT.tryDecode(accessToken);
    Map<String, dynamic> payload = jwt?.payload as Map<String, dynamic>;
    DateTime expireTime =
    DateTime.fromMillisecondsSinceEpoch((payload['exp'] as int) * 1000);
    if (expireTime.isBefore(DateTime.now())) {
      return true;
    }
    return false;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class ContentTypeInterceptor implements InterceptorContract{
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.headers['Content-Type'] = 'application/json';
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}
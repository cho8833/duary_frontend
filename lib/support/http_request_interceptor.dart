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

      // application jwt 는 interceptResponse 에서 로컬 저장소에 저장 -> 따로 저장할 필요 없음
      // await tokenProvider.storeAccessToken(accessToken);
      // await tokenProvider.storeRefreshToken(res.refreshToken);
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

  // token 이 발행되면 response body 에도 token 이 오지만, header 에도 token 을 넣어줌
  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}

class ContentTypeInterceptor implements InterceptorContract {

  final TokenProvider tokenProvider = TokenProvider();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.headers['Content-Type'] = 'application/json';
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {

    String? accessToken = data.headers?["access_token"];
    String? refreshToken = data.headers?["refresh_token"];

    if (accessToken == null || refreshToken == null) {
      return data;
    }

    await tokenProvider.storeAccessToken(accessToken);
    await tokenProvider.storeRefreshToken(refreshToken);

    return data;
  }
}

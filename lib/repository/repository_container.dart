import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:duary/repository/auth_repository.dart';
import 'package:duary/repository/impl/auth_repository_impl.dart';
import 'package:duary/repository/impl/member_repository_impl.dart';
import 'package:duary/repository/member_repository.dart';
import 'package:duary/repository/secure_storage.dart';
import 'package:duary/support/http_request_interceptor.dart';

class RepositoryContainer {
  late final AuthRepository authRepository;
  late final MemberRepository memberRepository;

  RepositoryContainer._internal();

  void initialize(SecureStorage secureStorage) {
    TokenInterceptor interceptor = TokenInterceptor(secureStorage);
    ContentTypeInterceptor contentTypeInterceptor = ContentTypeInterceptor();
    Client client = InterceptedClient.build(
        interceptors: [contentTypeInterceptor], client: Client());
    Client interceptedClient = InterceptedClient.build(
        interceptors: [contentTypeInterceptor, interceptor], client: Client());
    authRepository = AuthRepositoryImpl(client, interceptedClient);
    memberRepository = MemberRepositoryImpl(interceptedClient);
    interceptor.authRepository = authRepository;
  }

  static final RepositoryContainer _instance = RepositoryContainer._internal();

  factory RepositoryContainer() {
    return _instance;
  }
}

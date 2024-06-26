import 'package:app_chat_proxy/core/common/result.dart';
import 'package:app_chat_proxy/core/network/http_method.dart';
import 'package:app_chat_proxy/domain/entities/token.dart';

import '../../../../core/network/sender.dart';



abstract class AuthApi {
  Future<Result<Object, Token>> authenticate(String userName, String password);
}

class AuthApiImp implements AuthApi {
  final Sender _sender;

  AuthApiImp({required Sender sender}) : _sender = sender;

  @override
  Future<Result<Object, Token>> authenticate(
      String userName, String password) async {
    final rs = await _sender.sendApiRequest<Object, Token,dynamic>(
      method: HttpMethod.post,
      dataParser: (json) => Token(
          accessToken: json["access_token"], tokenType: json["token_type"]),
      body: {
        'grant_type': '',
        'username': userName,
        'password': password,
        'scope': '',
        'client_id': '',
        'client_secret': ''
      },
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    return rs;
  }
}

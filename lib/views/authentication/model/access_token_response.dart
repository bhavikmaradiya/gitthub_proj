
import 'dart:convert';

AccessTokenResponse accessTokenResponseFromJson(String str) =>
    AccessTokenResponse.fromJson(json.decode(str));

String accessTokenResponseToJson(AccessTokenResponse data) =>
    json.encode(data.toJson());

class AccessTokenResponse {
  AccessTokenResponse({
    required this.accessToken,
    required this.scope,
    required this.tokenType,
  });

  String accessToken;
  String scope;
  String tokenType;

  factory AccessTokenResponse.fromJson(Map<dynamic, dynamic> json) =>
      AccessTokenResponse(
        accessToken: json["access_token"],
        scope: json["scope"],
        tokenType: json["token_type"],
      );

  Map<dynamic, dynamic> toJson() => {
        "access_token": accessToken,
        "scope": scope,
        "token_type": tokenType,
      };
}

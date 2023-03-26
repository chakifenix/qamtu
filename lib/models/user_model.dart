class UserModel {
  final String accessToken;
  final String refreshToken;
  final String firebaseToken;

  UserModel(this.accessToken, this.refreshToken, this.firebaseToken);

  UserModel.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'],
        firebaseToken = json['firebaseToken']
  ;

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'firebaseToken': firebaseToken
  };
}
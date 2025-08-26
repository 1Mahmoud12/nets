class RegisterParams {
  final String email;
  final String password;
  final String deviceId;
  final String deviceType;
  final String deviceToken;
  final String deviceOs;
  final String deviceVersion;
  final String name;
  final String phone;
  final String passwordConfirmation;
  final bool agree;

  RegisterParams({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.deviceType,
    required this.deviceToken,
    required this.deviceOs,
    required this.deviceVersion,
    required this.name,
    required this.phone,
    required this.passwordConfirmation,
    required this.agree,
  });

  Map<String, Object> toJson() => {
    'email': email,
    'password': password,
    'device_id': deviceId,
    'device_type': deviceType,
    'device_token': deviceToken,
    'device_os': deviceOs,
    'device_version': deviceVersion,
    'name': name,
    'phone': phone,
    'password_confirmation': passwordConfirmation,
    'agree': agree ? 1 : 0,
  };
}

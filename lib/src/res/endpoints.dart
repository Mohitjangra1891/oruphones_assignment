import 'base.dart';

class Endpoints {
  static const _base = BasePaths.baseUrl;
  static const isLoggedIn = "${BasePaths.baseUrl}/isLoggedIn";
  static const otpValidate = "${BasePaths.baseUrl}/login/otpValidate";
  static const login = "${BasePaths.baseUrl}/restaurant/login";
  static const register = "${BasePaths.baseUrl}/restaurant/register";
}

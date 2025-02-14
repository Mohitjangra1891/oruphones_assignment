import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:oruphones_assignment/src/utils/SharedPrefHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res/endpoints.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  // final api = ref.watch(apiProvider);
  return AuthRepo();
});

class AuthRepo {
  // static final AuthRepo _instance = AuthRepo._internal();

  // factory AuthRepo() => _instance;
  // final http.Client _client = http.Client();

  static const String baseUrl = "http://40.90.224.241:5000";

  // AuthRepo._internal();

  Future<http.Response?> updateUserName({required int countryCode, required String username}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('auth_cookie');
      final sessionData = await SharedPrefHelper.loadSession();

      final response = await http.post(Uri.parse("$baseUrl/update"),
          headers: {"Content-Type": "application/json", "Cookie": "$cookie", "X-Csrf-Token": "${sessionData.csrfToken}"},
          body: jsonEncode(
            {"countryCode": 91, "userName": username},
          ));

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print(response.headers);
      return response;
    } catch (e) {
      print("update userName failed:}");
      print("exception-- $e");
      return null;
    }
  }

  Future<http.Response?> createOtp({required int countryCode, required int number}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login/otpCreate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"countryCode": 91, "mobileNumber": number}),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print(response.headers);
      return response;
    } catch (e) {
      print("OTP creation failed:}");

      print("exception-- $e");
      return null;
    }
  }

  Future<http.Response?> validateOtpAndStoreCookie({required int countryCode, required int number, required int otp}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login/otpValidate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "countryCode": countryCode,
          "mobileNumber": number,
          "otp": otp // Last 4 digits as OTP
        }),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print(response.headers);
      return response;
    } catch (e) {
      print("OTP validation failed:}");

      print("exception-- $e");
      return null;
    }
  }

  Future<http.Response?> getAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cookie = prefs.getString('auth_cookie');

      final response = await http.get(
        Uri.parse(Endpoints.isLoggedIn),
        headers: {"Cookie": cookie ?? ""},
      );
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("Response Body: ${response.headers['set-cookie']}");
      return response;
    } catch (e) {
      print("exception-- $e");

      return null;
    }
  }
}

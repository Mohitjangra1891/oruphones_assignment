import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oruphones_assignment/src/common/providers/common_providers.dart';
import 'package:oruphones_assignment/src/modals/userModel.dart';
import 'package:oruphones_assignment/src/utils/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionState {
  final bool isLoggedIn;
  final String sessionId;
  final String csrfToken;

  SessionState({
    required this.isLoggedIn,
    required this.sessionId,
    required this.csrfToken,
  });

  factory SessionState.fromJson(Map<String, dynamic> json) {
    return SessionState(
      isLoggedIn: json['isLoggedIn'] ?? false,
      sessionId: json['sessionId'] ?? '',
      csrfToken: json['csrfToken'] ?? '',
    );
  }
}

class SharedPrefKeys {
  static const String isLoggedIn = 'isLoggedIn';
  static const String auth_cookie = 'auth_cookie';
  static const String userData = 'userData';
  static const String sessionID = 'sessionID';
  static const String csrfToken = 'csrfToken';
}

class SharedPrefHelper {
  // / Save a token securely
  static Future<void> saveSession(SessionState session) async {
    if (session.sessionId.isEmpty && session.csrfToken.isEmpty) {
      throw Exception("session id and crsfToken cannot be empty");
    }
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      await _prefs.setBool(SharedPrefKeys.isLoggedIn, session.isLoggedIn);
      await _prefs.setString(SharedPrefKeys.sessionID, session.sessionId);
      await _prefs.setString(SharedPrefKeys.csrfToken, session.csrfToken);
      log("\nadded session\n", name: "SharedPrefHelper");
    } catch (e) {
      print("Error saving token: $e");
      throw Exception("Failed to save token");
    }
  }

  static Future<SessionState> loadSession() async {
    final _prefs = await SharedPreferences.getInstance();
    return SessionState(
      isLoggedIn: _prefs.getBool('isLoggedIn') ?? false,
      sessionId: _prefs.getString('sessionId') ?? '',
      csrfToken: _prefs.getString('csrfToken') ?? '',
    );
  }

  static Future<void> clearSession() async {
    final _prefs = await SharedPreferences.getInstance();
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      await _prefs.setBool(SharedPrefKeys.isLoggedIn, false);
      await _prefs.setString(SharedPrefKeys.sessionID, '');
      await _prefs.setString(SharedPrefKeys.csrfToken, '');
      log("\removed session\n", name: "SharedPrefHelper");
    } catch (e) {
      print("Error saving token: $e");
      throw Exception("Failed to save token");
    }
  }

  static Future<void> saveUserData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(user.toJson()));
      log("\nadded userdata\n", name: "SharedPrefHelper");
    } catch (e) {
      print("Error saving userdata: $e");
      throw Exception("Failed to save userdata");
    }
  }

  static Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      return UserModel.fromJson(jsonDecode(userDataString));
    }
    return null;
  }

  // Function to update only the userName in SharedPreferences
  static Future<void> updateUserName(String newName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userData = prefs.getString('userData');

      if (userData != null) {
        Map<String, dynamic> userMap = jsonDecode(userData);
        userMap['userName'] = newName; // Update only the userName field

        await prefs.setString('userData', jsonEncode(userMap));
        debugPrint("Updated userName successfully");
      }
    } catch (e) {
      debugPrint("Error updating userName: $e");
    }
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }

  static Future<void> updateFavoriteList(String listingId, bool isFav, WidgetRef ref) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userData = prefs.getString('userData');

      if (userData != null) {
        Map<String, dynamic> userMap = jsonDecode(userData);
        List<String> favoriteListings = List<String>.from(userMap['favListings'] ?? []);

        if (isFav) {
          // Add to favorites if not already present
          if (!favoriteListings.contains(listingId)) {
            favoriteListings.add(listingId);
          }
        } else {
          // Remove from favorites
          favoriteListings.remove(listingId);
        }

        userMap['favListings'] = favoriteListings; // Update the favorites list

        ref.read(userProvider.notifier).state = UserModel.fromJson(userMap);

        await prefs.setString('userData', jsonEncode(userMap));
        debugPrint("Updated favorite list successfully");
      }
    } catch (e) {
      debugPrint("Error updating favorite list: $e");
    }
  }

  /// Check if a token exists
  // static Future<bool> hasToken() async {
  //   try {
  //     final SharedPreferences _prefs = await SharedPreferences.getInstance();
  //
  //     final String? token = _prefs.getString('auth_token');
  //     return token != null && token.isNotEmpty;
  //   } catch (e) {
  //     print("Error checking token existence: $e");
  //     return false; // Default to no token if an error occurs
  //   }
  // }

  /// Save generic key-value pair
  static Future<void> saveValue<T>(String key, T value) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else {
        throw Exception("Unsupported type for SharedPreferences");
      }
      log("\nadded to shared prefernece key:$key   ---  value: $value\n", name: "SharedPrefHelper");
    } catch (e) {
      print("Error saving value: $e");
      throw Exception("Failed to save value for key: $key");
    }
  }

  /// Retrieve generic key-value pair
  static Future<T?> getValue<T>(String key) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      // log("Retrieving key:$key as type:${T.toString()}", name: "SharedPrefHelper");

      if (T == String) {
        return _prefs.getString(key) as T?;
      } else if (T == int) {
        return _prefs.getInt(key) as T?;
      } else if (T == bool) {
        return _prefs.getBool(key) as T?;
      } else if (T == double) {
        return _prefs.getDouble(key) as T?;
      } else {
        throw Exception("Unsupported type for SharedPreferences");
      }
    } catch (e) {
      print("Error retrieving value: $e");
      return null; // Return null if an error occurs
    }
  }

  /// Remove a key-value pair
  static Future<void> removeValue(String key) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();

      await _prefs.remove(key);
    } catch (e) {
      print("Error removing value: $e");
      throw Exception("Failed to remove value for key: $key");
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oruphones_assignment/src/features/auth/views/addNameScreen.dart';
import 'package:oruphones_assignment/src/features/auth/views/sheets/addNameBottomSheet.dart';
import 'package:oruphones_assignment/src/features/auth/views/sheets/verifyOtp_bottom_sheet.dart';
import 'package:oruphones_assignment/src/features/home/controller/products_provider.dart';
import 'package:oruphones_assignment/src/features/home/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/providers/common_providers.dart';
import '../../../common/services/snackBar_service.dart';
import '../../../modals/userModel.dart';
import '../../../utils/SharedPrefHelper.dart';
import '../../../utils/router.dart';
import '../../home/repo/home_repo.dart';
import '../repo/auth_repo.dart';
import '../views/verifyOtp_screen.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepoProvider);
  return AuthNotifier(authRepository);
});

// Provider to listen to the login state only
final isLoggedInStateProvider = Provider<AsyncValue<void>>((ref) {
  return ref.watch(authProvider.select((authState) => authState.isLogedInState));
});
final createOtpStateProvider = Provider<AsyncValue<void>>((ref) {
  return ref.watch(authProvider.select((authState) => authState.createOtpState));
});
final verifyOtpStateProvider = Provider<AsyncValue<void>>((ref) {
  return ref.watch(authProvider.select((authState) => authState.verifyOtpState));
});
final addNameStateProvider = Provider<AsyncValue<void>>((ref) {
  return ref.watch(authProvider.select((authState) => authState.addNameState));
});

// State class to hold the individual states for login, register, and verify OTP
class AuthState {
  final AsyncValue<void> createOtpState;
  final AsyncValue<void> isLogedInState;
  final AsyncValue<void> verifyOtpState;
  final AsyncValue<void> addNameState;

  AuthState({
    this.createOtpState = const AsyncValue.data(null),
    this.isLogedInState = const AsyncValue.data(null),
    this.verifyOtpState = const AsyncValue.data(null),
    this.addNameState = const AsyncValue.data(null),
  });

  AuthState copyWith({
    AsyncValue<void>? createOtpState,
    AsyncValue<void>? isLogedInState,
    AsyncValue<void>? verifyOtpState,
    AsyncValue<void>? addNameState,
  }) {
    return AuthState(
      createOtpState: createOtpState ?? this.createOtpState,
      isLogedInState: isLogedInState ?? this.isLogedInState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      addNameState: addNameState ?? this.addNameState,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepo _authRepo;

  AuthNotifier(this._authRepo) : super(AuthState());

  // Login method
  Future<void> isUserLoggedIn(WidgetRef ref, BuildContext context) async {
    try {
      state = state.copyWith(isLogedInState: const AsyncValue.loading());
      final response = await _authRepo.getAuthStatus();

      final Map<String, dynamic> responseBody = json.decode(response!.body);

      if (response.statusCode == 200 && responseBody['isLoggedIn'] == true) {
        ref.read(isLoggedInProvider.notifier).state = true;

        String? rawCookie = response.headers['set-cookie'];

        if (rawCookie != null) {
          String sessionCookie = rawCookie.split(';')[0]; // Extract only the session token
          await SharedPrefHelper.saveValue(SharedPrefKeys.auth_cookie, sessionCookie);
          print("Cookie stored: $sessionCookie");
        } else {
          print("No cookie found in response.");
        }
       await SharedPrefHelper.saveSession(SessionState(isLoggedIn: true, sessionId: responseBody['sessionId'], csrfToken: responseBody['csrfToken']));
        final userdata = UserModel.fromJson(responseBody["user"] ?? {});
        ref.read(userProvider.notifier).state = userdata;

       await SharedPrefHelper.saveUserData(userdata);
      } else {
        // SnackBarService.showSnackBar(context: context, message: "User is not Logged In ");
      }

      state = state.copyWith(isLogedInState: const AsyncValue.data(null));
    } catch (error, stackTrace) {
      state = state.copyWith(isLogedInState: AsyncValue.error(error, stackTrace));
    }
  }

  Future<void> createOtp(int countryCode, int phoneNumber, BuildContext context, {required bool isBottomSheet, String? listingId}) async {
    try {
      state = state.copyWith(createOtpState: const AsyncValue.loading());
      final response = await _authRepo.createOtp(countryCode: countryCode, number: phoneNumber);
      final Map<String, dynamic> responseBody = json.decode(response!.body);

      if (response.statusCode == 200 && responseBody["status"] == "SUCCESS") {
        SnackBarService.showSnackBar(context: context, message: responseBody["reason"]);

        if (isBottomSheet) {
          // context.pop();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) => verifyOtpBottomSheet(
              phoneNumber: phoneNumber.toString(),
              listingId: listingId!,
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpVerificationScreen(
                        phoneNumber: '$phoneNumber',
                      )));
        }

        // context.go(routeNames.home);
      } else {
        // SnackBarService.showSnackBar(context: context, message: "Otp not created");
      }

      state = state.copyWith(createOtpState: const AsyncValue.data(null));
    } catch (error, stackTrace) {
      state = state.copyWith(createOtpState: AsyncValue.error(error, stackTrace));
    }
  }

// Verify OTP method
  Future<void> verifyOtp(int countryCode, int phoneNumber, int otp, BuildContext context, WidgetRef ref,
      {bool? isBottomSheet = false, String? listingID}) async {
    try {
      state = state.copyWith(verifyOtpState: const AsyncValue.loading());
      final response = await _authRepo.validateOtpAndStoreCookie(countryCode: countryCode, number: phoneNumber, otp: otp);
      final Map<String, dynamic> responseBody = json.decode(response!.body);

      if (response.statusCode == 200 && responseBody["status"] == "SUCCESS") {
        ref.read(isLoggedInProvider.notifier).state = true;

        String? rawCookie = response.headers['set-cookie'];

        if (rawCookie != null) {
          String sessionCookie = rawCookie.split(';')[0]; // Extract only the session token
          await SharedPrefHelper.saveValue(SharedPrefKeys.auth_cookie, sessionCookie);
          print("Cookie stored: $sessionCookie");
        } else {
          print("No cookie found in response.");
        }
        // SharedPrefHelper.saveSession(SessionState(isLoggedIn: true, sessionId: responseBody['sessionId'], csrfToken: responseBody['csrfToken']));
        await isUserLoggedIn(ref, context);

        final userdata = UserModel.fromJson(responseBody["user"] ?? {});

        if (isBottomSheet == true) {
          await ref.read(HomeRepoProvider).addtoFav(context: context, ref: ref, listingID: listingID ?? "", toggleValue: true);

          context.pop();
          context.pop();
          if (userdata.userName == "") {
            // context.go(routeNames.home + routeNames.addUserName);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => addNameBottomSheet(
                listingId: listingID!,
              ),
            );
          }
        } else {
          // SharedPrefHelper.saveUserData(userdata);
          if (userdata.userName == "") {
            context.go(routeNames.addUserName);
          } else {
            context.go(routeNames.home);
          }
        }

        // SnackBarService.showSnackBar(context: context, message: responseBody["reason"]);
      } else {
        SnackBarService.showSnackBar(context: context, message: responseBody["error"]);
      }

      state = state.copyWith(verifyOtpState: const AsyncValue.data(null));
    } catch (error, stackTrace) {
      state = state.copyWith(verifyOtpState: AsyncValue.error(error, stackTrace));
    }
  }

  Future<void> updateUserName(int countryCode, String userName, BuildContext context, WidgetRef ref, {String? listingID}) async {
    try {
      state = state.copyWith(addNameState: const AsyncValue.loading());

      await isUserLoggedIn(ref, context);
      final response = await _authRepo.updateUserName(countryCode: countryCode, username: userName);
      final Map<String, dynamic> responseBody = json.decode(response!.body);

      if (response.statusCode == 200 && responseBody["status"] == "SUCCESS") {
        // SnackBarService.showSnackBar(context: context, message: responseBody["reason"]);
        SharedPrefHelper.updateUserName(userName);

        context.pop();
        context.go(routeNames.home);
      } else {
        SnackBarService.showSnackBar(context: context, message: "unauthorized");
      }

      state = state.copyWith(addNameState: const AsyncValue.data(null));
    } catch (error, stackTrace) {
      state = state.copyWith(addNameState: AsyncValue.error(error, stackTrace));
    }
  }
}

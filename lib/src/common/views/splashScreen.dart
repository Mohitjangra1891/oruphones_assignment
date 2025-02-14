import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:oruphones_assignment/src/common/providers/common_providers.dart';
import 'package:oruphones_assignment/src/features/auth/controller/authController.dart';
import 'package:oruphones_assignment/src/res/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/SharedPrefHelper.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkToken();
  }

  Future<void> _checkToken() async {
    final session = await SharedPrefHelper.loadSession();
    final userdata = await SharedPrefHelper.getUserData();

    ref.read(isLoggedInProvider.notifier).state = session.isLoggedIn;


    if (userdata?.userName == '' && session.isLoggedIn == true) {
      Future.delayed(const Duration(seconds: 2), () {
        // context.go(routeNames.LoginScreen);
        context.go(routeNames.addUserName);
      });
    } else {
      // await  ref.read(authProvider.notifier).verifyOtp(91,8307251891,1891,context);

      await ref.read(authProvider.notifier).isUserLoggedIn(ref, context);

      Future.delayed(const Duration(seconds: 2), () {
        context.go(routeNames.home);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(height: double.infinity, width: double.infinity, child: Lottie.asset('assets/Splash.json')),
    );
  }
}
